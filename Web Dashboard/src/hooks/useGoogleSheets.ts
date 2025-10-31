import { useEffect, useState } from "react";

export interface GoogleSheetsData {
  sensors: Array<{
    id: string;
    lat: number;
    lng: number;
    fillLevel: number;
    odor: number;
    status: "online" | "warning" | "critical";
  }>;
  routes: Array<{
    id: string;
    path: { x: number; y: number }[];
    status: "active" | "completed" | "pending";
    vehicle: string;
  }>;
  stats: {
    totalBins: number;
    activeRoutes: number;
    vehicleUtilization: number;
    wasteCollected: number;
  };
  maintenanceData: Array<{
    date: string;
    predicted: number;
    actual: number;
    threshold: number;
  }>;
}

// Mock data generator with realistic patterns
// Jaipur city center coordinates: 26.9124° N, 75.7873° E
const generateMockData = (): GoogleSheetsData => {
  const jaipurCenter = { lat: 26.9124, lng: 75.7873 };
  
  // Generate realistic sensor data with patterns
  const sensors = Array.from({ length: 45 }, (_, i) => {
    const fillLevel = i < 5 ? 85 + Math.floor(Math.random() * 15) : // Critical bins
                      i < 12 ? 60 + Math.floor(Math.random() * 20) : // Warning bins
                      20 + Math.floor(Math.random() * 40); // Normal bins
    
    const odor = fillLevel > 80 ? 7 + Math.floor(Math.random() * 3) :
                 fillLevel > 60 ? 4 + Math.floor(Math.random() * 3) :
                 1 + Math.floor(Math.random() * 3);
    
    const status = fillLevel > 85 ? "critical" as const :
                   fillLevel > 60 ? "warning" as const :
                   "online" as const;
    
    return {
      id: `BIN-${String(i + 1).padStart(3, "0")}`,
      lat: jaipurCenter.lat + (Math.random() - 0.5) * 0.15,
      lng: jaipurCenter.lng + (Math.random() - 0.5) * 0.15,
      fillLevel,
      odor,
      status,
    };
  });

  const routes = [
    {
      id: "route-1",
      path: [
        { x: 50, y: 50 },
        { x: 100, y: 80 },
        { x: 150, y: 60 },
        { x: 200, y: 100 },
        { x: 250, y: 90 },
      ],
      status: "active" as const,
      vehicle: "Truck A-01",
    },
    {
      id: "route-2",
      path: [
        { x: 60, y: 150 },
        { x: 120, y: 180 },
        { x: 180, y: 160 },
        { x: 240, y: 190 },
        { x: 300, y: 170 },
      ],
      status: "completed" as const,
      vehicle: "Truck B-02",
    },
    {
      id: "route-3",
      path: [
        { x: 80, y: 220 },
        { x: 140, y: 240 },
        { x: 200, y: 230 },
        { x: 260, y: 250 },
      ],
      status: "pending" as const,
      vehicle: "Truck C-03",
    },
  ];

  const criticalBins = sensors.filter((s) => s.status === "critical").length;
  const warningBins = sensors.filter((s) => s.status === "warning").length;
  
  const stats = {
    totalBins: sensors.length,
    activeRoutes: routes.filter((r) => r.status === "active").length,
    vehicleUtilization: 78,
    wasteCollected: 18750,
  };

  const maintenanceData = [
    { date: "Mon", predicted: 58, actual: 55, threshold: 85 },
    { date: "Tue", predicted: 62, actual: 64, threshold: 85 },
    { date: "Wed", predicted: 67, actual: 66, threshold: 85 },
    { date: "Thu", predicted: 71, actual: 73, threshold: 85 },
    { date: "Fri", predicted: 76, actual: 74, threshold: 85 },
    { date: "Sat", predicted: 81, actual: 82, threshold: 85 },
    { date: "Sun", predicted: 84, actual: 86, threshold: 85 },
  ];

  return { sensors, routes, stats, maintenanceData };
};

export const useGoogleSheets = (sheetUrl?: string) => {
  const [data, setData] = useState<GoogleSheetsData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        // TODO: Replace with actual Google Sheets API call
        // For now, using mock data
        await new Promise((resolve) => setTimeout(resolve, 1000)); // Simulate API delay
        const mockData = generateMockData();
        setData(mockData);
        setError(null);
      } catch (err) {
        setError("Failed to fetch data from Google Sheets");
        console.error(err);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
    // Refresh data every 30 seconds
    const interval = setInterval(fetchData, 30000);
    return () => clearInterval(interval);
  }, [sheetUrl]);

  return { data, loading, error };
};
