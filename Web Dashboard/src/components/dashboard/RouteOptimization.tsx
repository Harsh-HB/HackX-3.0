import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Route } from "lucide-react";
import { useEffect, useState } from "react";

interface RouteSegment {
  id: string;
  path: { x: number; y: number }[];
  status: "active" | "completed" | "pending";
  vehicle: string;
}

interface RouteOptimizationProps {
  routes: RouteSegment[];
}

export const RouteOptimization = ({ routes }: RouteOptimizationProps) => {
  const [animationProgress, setAnimationProgress] = useState(0);

  useEffect(() => {
    const interval = setInterval(() => {
      setAnimationProgress((prev) => (prev + 1) % 100);
    }, 50);
    return () => clearInterval(interval);
  }, []);

  const getRouteColor = (status: string) => {
    switch (status) {
      case "active":
        return "stroke-primary";
      case "completed":
        return "stroke-accent";
      case "pending":
        return "stroke-muted-foreground";
      default:
        return "stroke-muted";
    }
  };

  return (
    <Card className="col-span-full lg:col-span-2 animate-slide-in">
      <CardHeader>
        <CardTitle className="flex items-center gap-2 gradient-text">
          <Route className="h-5 w-5" />
          AI-Optimized Collection Routes
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="relative w-full h-[300px] glass-intense rounded-lg overflow-hidden">
          <svg className="w-full h-full" viewBox="0 0 400 300">
            {/* Background grid */}
            <defs>
              <linearGradient id="routeGradient" x1="0%" y1="0%" x2="100%" y2="0%">
                <stop offset="0%" stopColor="hsl(180, 100%, 50%)" stopOpacity="0.8" />
                <stop offset="50%" stopColor="hsl(320, 100%, 50%)" stopOpacity="0.8" />
                <stop offset="100%" stopColor="hsl(180, 100%, 50%)" stopOpacity="0.8" />
              </linearGradient>
              <filter id="glow">
                <feGaussianBlur stdDeviation="3" result="coloredBlur" />
                <feMerge>
                  <feMergeNode in="coloredBlur" />
                  <feMergeNode in="SourceGraphic" />
                </feMerge>
              </filter>
            </defs>

            {/* Render route paths */}
            {routes.map((route, idx) => {
              const pathData = route.path
                .map((point, i) => `${i === 0 ? "M" : "L"} ${point.x} ${point.y}`)
                .join(" ");

              return (
                <g key={route.id}>
                  {/* Route path */}
                  <path
                    d={pathData}
                    fill="none"
                    className={getRouteColor(route.status)}
                    strokeWidth="3"
                    strokeLinecap="round"
                    strokeDasharray={route.status === "active" ? "5,5" : "0"}
                    filter="url(#glow)"
                    style={{
                      strokeDashoffset: route.status === "active" ? -animationProgress : 0,
                    }}
                  />

                  {/* Route nodes */}
                  {route.path.map((point, pointIdx) => (
                    <circle
                      key={`${route.id}-${pointIdx}`}
                      cx={point.x}
                      cy={point.y}
                      r="4"
                      className={route.status === "active" ? "fill-primary" : "fill-muted"}
                      filter="url(#glow)"
                    >
                      {route.status === "active" && (
                        <animate
                          attributeName="r"
                          values="4;6;4"
                          dur="1.5s"
                          repeatCount="indefinite"
                        />
                      )}
                    </circle>
                  ))}

                  {/* Vehicle indicator for active routes */}
                  {route.status === "active" && (
                    <g>
                      <circle
                        cx={route.path[0].x}
                        cy={route.path[0].y}
                        r="8"
                        className="fill-primary"
                        opacity="0.8"
                        filter="url(#glow)"
                      >
                        <animateMotion dur="10s" repeatCount="indefinite" path={pathData} />
                      </circle>
                      <circle
                        cx={route.path[0].x}
                        cy={route.path[0].y}
                        r="12"
                        className="fill-primary"
                        opacity="0.3"
                      >
                        <animateMotion dur="10s" repeatCount="indefinite" path={pathData} />
                        <animate
                          attributeName="r"
                          values="12;16;12"
                          dur="1.5s"
                          repeatCount="indefinite"
                        />
                      </circle>
                    </g>
                  )}
                </g>
              );
            })}
          </svg>

          {/* Route legend */}
          <div className="absolute bottom-4 left-4 glass-panel p-3 rounded-lg space-y-2">
            {routes.map((route) => (
              <div key={route.id} className="flex items-center gap-2 text-xs">
                <div
                  className={`w-3 h-3 rounded-full ${
                    route.status === "active"
                      ? "bg-primary animate-pulse"
                      : route.status === "completed"
                      ? "bg-accent"
                      : "bg-muted-foreground"
                  }`}
                />
                <span className="text-foreground">{route.vehicle}</span>
              </div>
            ))}
          </div>
        </div>
      </CardContent>
    </Card>
  );
};
