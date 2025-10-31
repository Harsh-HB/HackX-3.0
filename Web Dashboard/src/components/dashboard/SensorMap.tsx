import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Button } from "@/components/ui/button";
import { MapPin, Route, Loader2 } from "lucide-react";
import { useEffect, useRef, useState } from "react";
import L from "leaflet";
import "leaflet/dist/leaflet.css";
import { optimizeRoute } from "@/utils/routeOptimization";
import { toast } from "sonner";

interface Sensor {
  id: string;
  lat: number;
  lng: number;
  fillLevel: number;
  odor: number;
  status: "online" | "warning" | "critical";
}

interface SensorMapProps {
  sensors: Sensor[];
}

export const SensorMap = ({ sensors }: SensorMapProps) => {
  const mapRef = useRef<L.Map | null>(null);
  const mapContainerRef = useRef<HTMLDivElement>(null);
  const markersRef = useRef<L.CircleMarker[]>([]);
  const routeLineRef = useRef<L.Polyline | null>(null);
  const [isOptimizing, setIsOptimizing] = useState(false);
  const [routeInfo, setRouteInfo] = useState<{
    distance: number;
    time: number;
    bins: number;
  } | null>(null);

  const getMarkerColor = (status: string) => {
    switch (status) {
      case "online":
        return "#00ffff"; // cyan
      case "warning":
        return "#facc15"; // yellow
      case "critical":
        return "#ef4444"; // red
      default:
        return "#6b7280"; // gray
    }
  };

  useEffect(() => {
    if (!mapContainerRef.current || mapRef.current) return;

    // Initialize map
    const map = L.map(mapContainerRef.current, {
      center: [26.9124, 75.7873],
      zoom: 12,
      zoomControl: true,
    });

    // Add dark-themed tile layer
    L.tileLayer("https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png", {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>',
      className: "map-tiles",
    }).addTo(map);

    mapRef.current = map;

    return () => {
      if (mapRef.current) {
        mapRef.current.remove();
        mapRef.current = null;
      }
    };
  }, []);

  useEffect(() => {
    if (!mapRef.current) return;

    // Clear existing markers
    markersRef.current.forEach((marker) => marker.remove());
    markersRef.current = [];

    // Add new markers
    sensors.forEach((sensor) => {
      const color = getMarkerColor(sensor.status);
      const marker = L.circleMarker([sensor.lat, sensor.lng], {
        color: color,
        fillColor: color,
        fillOpacity: 0.8,
        weight: 2,
        radius: 6,
      });

      const popupContent = `
        <div class="p-2 space-y-1 min-w-[150px]">
          <div class="font-semibold text-sm" style="color: ${color}">${sensor.id}</div>
          <div class="text-xs">Fill Level: ${sensor.fillLevel}%</div>
          <div class="text-xs">Odor: ${sensor.odor}/10</div>
          <div class="font-medium text-xs" style="color: ${color}">
            Status: ${sensor.status.toUpperCase()}
          </div>
        </div>
      `;

      marker.bindPopup(popupContent);
      marker.on("mouseover", () => marker.openPopup());
      marker.addTo(mapRef.current!);
      markersRef.current.push(marker);
    });
  }, [sensors]);

  const handleOptimizeRoute = async () => {
    setIsOptimizing(true);
    
    // Simulate ML computation time
    await new Promise(resolve => setTimeout(resolve, 1500));
    
    const depotLat = 26.9124;
    const depotLng = 75.7873;
    const result = optimizeRoute(sensors, depotLat, depotLng);
    
    if (result.route.length === 0) {
      toast.info(result.message || "No optimal route found");
      setIsOptimizing(false);
      return;
    }

    // Clear previous route
    if (routeLineRef.current) {
      routeLineRef.current.remove();
    }

    // Build route coordinates: depot -> bins -> depot
    const routeCoords: [number, number][] = [
      [depotLat, depotLng],
      ...result.route.map(s => [s.lat, s.lng] as [number, number]),
      [depotLat, depotLng],
    ];

    // Draw route on map
    const routeLine = L.polyline(routeCoords, {
      color: '#00ffff',
      weight: 3,
      opacity: 0.8,
      dashArray: '10, 10',
      className: 'animate-pulse',
    }).addTo(mapRef.current!);

    routeLineRef.current = routeLine;

    // Fit map to show entire route
    mapRef.current?.fitBounds(routeLine.getBounds(), { padding: [50, 50] });

    setRouteInfo({
      distance: result.totalDistance,
      time: result.estimatedTime,
      bins: result.binsToCollect,
    });

    toast.success(`Optimal route calculated! ${result.binsToCollect} bins to collect.`);
    setIsOptimizing(false);
  };

  return (
    <Card className="col-span-full animate-scale-in">
      <CardHeader>
        <div className="flex items-center justify-between">
          <CardTitle className="flex items-center gap-2 gradient-text">
            <MapPin className="h-5 w-5" />
            IoT Sensor Network - Jaipur City
          </CardTitle>
          <div className="flex items-center gap-3">
            {routeInfo && (
              <div className="text-xs space-y-0.5 text-right">
                <div className="text-primary font-medium">{routeInfo.bins} bins • {routeInfo.distance} km</div>
                <div className="text-muted-foreground">Est. {routeInfo.time} min</div>
              </div>
            )}
            <Button
              onClick={handleOptimizeRoute}
              disabled={isOptimizing}
              variant="cyber"
              size="sm"
              className="gap-2"
            >
              {isOptimizing ? (
                <>
                  <Loader2 className="h-4 w-4 animate-spin" />
                  Optimizing...
                </>
              ) : (
                <>
                  <Route className="h-4 w-4" />
                  Get Optimal Route
                </>
              )}
            </Button>
          </div>
        </div>
      </CardHeader>
      <CardContent>
        <div className="relative w-full h-[400px] glass-intense rounded-lg overflow-hidden">
          <div ref={mapContainerRef} className="w-full h-full rounded-lg" />
          
          {/* Animated scan line overlay */}
          <div className="absolute inset-0 pointer-events-none">
            <div className="w-full h-0.5 bg-gradient-to-r from-transparent via-primary to-transparent opacity-30 animate-pulse" />
          </div>
        </div>
      </CardContent>
    </Card>
  );
};
