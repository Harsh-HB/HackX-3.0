import { Activity, Trash2, TrendingUp, Truck } from "lucide-react";
import { StatCard } from "@/components/dashboard/StatCard";
import { SensorMap } from "@/components/dashboard/SensorMap";
import { RouteOptimization } from "@/components/dashboard/RouteOptimization";
import { PredictiveMaintenance } from "@/components/dashboard/PredictiveMaintenance";
import { AlertsPanel } from "@/components/dashboard/AlertsPanel";
import { BinStatusTable } from "@/components/dashboard/BinStatusTable";
import { useGoogleSheets } from "@/hooks/useGoogleSheets";
import { useEffect, useMemo } from "react";
import { toast } from "sonner";

const Index = () => {
  const { data, loading, error } = useGoogleSheets();

  // Generate realistic alerts based on sensor data
  const alerts = useMemo(() => {
    if (!data) return [];
    
    const criticalBins = data.sensors.filter((s) => s.status === "critical");
    const warningBins = data.sensors.filter((s) => s.status === "warning");
    
    return [
      ...criticalBins.slice(0, 3).map((bin) => ({
        id: `alert-${bin.id}`,
        type: "critical" as const,
        title: `${bin.id} Requires Immediate Collection`,
        description: `Fill level at ${bin.fillLevel}%, odor index ${bin.odor}/10. Priority dispatch recommended.`,
        time: "5 minutes ago",
      })),
      ...warningBins.slice(0, 2).map((bin, idx) => ({
        id: `alert-w-${bin.id}`,
        type: "warning" as const,
        title: `${bin.id} Approaching Capacity`,
        description: `Fill level at ${bin.fillLevel}%. Schedule collection within 24 hours.`,
        time: `${15 + idx * 10} minutes ago`,
      })),
      {
        id: "alert-efficiency",
        type: "info" as const,
        title: "Route Optimization Complete",
        description: "New optimized route generated. Estimated 15% reduction in travel time.",
        time: "1 hour ago",
      },
    ];
  }, [data]);

  useEffect(() => {
    if (error) {
      toast.error("Failed to load dashboard data");
    }
  }, [error]);

  if (loading) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center space-y-4">
          <div className="relative w-16 h-16 mx-auto">
            <div className="absolute inset-0 rounded-full border-4 border-primary/30" />
            <div className="absolute inset-0 rounded-full border-4 border-t-primary animate-spin" />
          </div>
          <p className="text-primary text-lg font-medium">Initializing Smart City Dashboard...</p>
        </div>
      </div>
    );
  }

  if (!data) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="text-center space-y-4">
          <p className="text-destructive text-lg">Failed to load dashboard data</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen p-4 md:p-8 space-y-8">
      {/* Header */}
      <header className="space-y-3 animate-fade-in border-b border-border pb-6">
        <div className="flex items-center gap-3">
          <div className="w-12 h-12 rounded bg-primary flex items-center justify-center">
            <Trash2 className="w-6 h-6 text-primary-foreground" />
          </div>
          <div>
            <h1 className="text-3xl md:text-4xl font-bold text-gov-title">
              Municipal Waste Management System
            </h1>
            <p className="text-muted-foreground text-sm">
              City of Innovation • Department of Public Works
            </p>
          </div>
        </div>
        <p className="text-gov-body max-w-3xl">
          Real-time monitoring and optimization of municipal waste collection services. Data updated every 15 minutes.
        </p>
        <div className="flex items-center gap-2 text-sm">
          <div className="w-2 h-2 rounded-full bg-success subtle-pulse" />
          <span className="text-success font-medium">System Operational</span>
          <span className="text-muted-foreground">• Last updated: {new Date().toLocaleTimeString()}</span>
        </div>
      </header>

      {/* KPI Stats Grid */}
      <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4 animate-slide-in">
        <StatCard
          title="Total Bins"
          value={data.stats.totalBins}
          icon={Trash2}
          trend="+12% from last week"
          iconColor="text-primary"
        />
        <StatCard
          title="Active Routes"
          value={data.stats.activeRoutes}
          icon={Truck}
          trend="3 vehicles deployed"
          iconColor="text-accent"
        />
        <StatCard
          title="Vehicle Utilization"
          value={`${data.stats.vehicleUtilization}%`}
          icon={Activity}
          trend="+5% efficiency"
          iconColor="text-green-400"
        />
        <StatCard
          title="Waste Collected"
          value={`${(data.stats.wasteCollected / 1000).toFixed(1)}t`}
          icon={TrendingUp}
          trend="Today's total"
          iconColor="text-yellow-400"
        />
      </div>

      {/* Alerts and Priority Queue */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        <AlertsPanel alerts={alerts} />
        <BinStatusTable sensors={data.sensors} />
      </div>

      {/* Main Dashboard Grid */}
      <div className="grid grid-cols-1 lg:grid-cols-4 gap-6">
        {/* Sensor Map - Full Width */}
        <SensorMap sensors={data.sensors} />

        {/* Route Optimization - 2/3 Width */}
        <RouteOptimization routes={data.routes} />

        {/* Predictive Maintenance - 2/3 Width */}
        <PredictiveMaintenance data={data.maintenanceData} />
      </div>

      {/* Footer */}
      <footer className="border-t border-border pt-8 mt-8 animate-fade-in">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6 text-sm text-muted-foreground">
          <div>
            <h3 className="font-semibold text-foreground mb-2">Contact Information</h3>
            <p>Department of Public Works</p>
            <p>123 Municipal Drive</p>
            <p>Phone: (555) 123-4567</p>
          </div>
          <div>
            <h3 className="font-semibold text-foreground mb-2">Business Hours</h3>
            <p>Monday - Friday: 8:00 AM - 5:00 PM</p>
            <p>Emergency Services: 24/7</p>
          </div>
          <div>
            <h3 className="font-semibold text-foreground mb-2">System Information</h3>
            <p>Version 2.1.0</p>
            <p>© 2025 City of Innovation</p>
            <p className="text-xs mt-2">Data provided for informational purposes only</p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
