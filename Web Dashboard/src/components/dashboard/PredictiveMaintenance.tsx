import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { Wrench } from "lucide-react";
import { LineChart, Line, XAxis, YAxis, CartesianGrid, Tooltip, ResponsiveContainer, Area, AreaChart } from "recharts";

interface MaintenanceData {
  date: string;
  predicted: number;
  actual: number;
  threshold: number;
}

interface PredictiveMaintenanceProps {
  data: MaintenanceData[];
}

export const PredictiveMaintenance = ({ data }: PredictiveMaintenanceProps) => {
  return (
    <Card className="col-span-full lg:col-span-2 animate-scale-in">
      <CardHeader>
        <CardTitle className="flex items-center gap-2 gradient-text">
          <Wrench className="h-5 w-5" />
          Predictive Maintenance
        </CardTitle>
      </CardHeader>
      <CardContent>
        <div className="w-full h-[300px]">
          <ResponsiveContainer width="100%" height="100%">
            <AreaChart data={data}>
              <defs>
                <linearGradient id="predictedGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(180, 100%, 50%)" stopOpacity={0} />
                </linearGradient>
                <linearGradient id="actualGradient" x1="0" y1="0" x2="0" y2="1">
                  <stop offset="5%" stopColor="hsl(320, 100%, 50%)" stopOpacity={0.8} />
                  <stop offset="95%" stopColor="hsl(320, 100%, 50%)" stopOpacity={0} />
                </linearGradient>
              </defs>
              <CartesianGrid strokeDasharray="3 3" stroke="hsl(230, 20%, 25%)" opacity={0.3} />
              <XAxis
                dataKey="date"
                stroke="hsl(180, 50%, 70%)"
                tick={{ fill: "hsl(180, 50%, 70%)", fontSize: 12 }}
              />
              <YAxis
                stroke="hsl(180, 50%, 70%)"
                tick={{ fill: "hsl(180, 50%, 70%)", fontSize: 12 }}
                label={{ value: "Maintenance Score", angle: -90, position: "insideLeft", fill: "hsl(180, 50%, 70%)" }}
              />
              <Tooltip
                contentStyle={{
                  backgroundColor: "hsla(230, 20%, 12%, 0.9)",
                  border: "1px solid hsl(180, 100%, 50%)",
                  borderRadius: "8px",
                  color: "hsl(180, 100%, 95%)",
                  backdropFilter: "blur(16px)",
                }}
                labelStyle={{ color: "hsl(180, 100%, 50%)" }}
              />
              <Area
                type="monotone"
                dataKey="predicted"
                stroke="hsl(180, 100%, 50%)"
                strokeWidth={3}
                fill="url(#predictedGradient)"
                name="Predicted"
              />
              <Area
                type="monotone"
                dataKey="actual"
                stroke="hsl(320, 100%, 50%)"
                strokeWidth={3}
                fill="url(#actualGradient)"
                name="Actual"
              />
              <Line
                type="monotone"
                dataKey="threshold"
                stroke="hsl(0, 100%, 50%)"
                strokeWidth={2}
                strokeDasharray="5 5"
                dot={false}
                name="Critical Threshold"
              />
            </AreaChart>
          </ResponsiveContainer>
        </div>

        {/* Maintenance alerts */}
        <div className="mt-4 grid grid-cols-1 md:grid-cols-3 gap-3">
          <div className="glass-panel p-3 rounded-lg glow-cyan">
            <div className="text-xs text-muted-foreground">Next Service</div>
            <div className="text-lg font-bold text-primary">3 days</div>
          </div>
          <div className="glass-panel p-3 rounded-lg glow-pink">
            <div className="text-xs text-muted-foreground">Vehicles Due</div>
            <div className="text-lg font-bold text-accent">2 units</div>
          </div>
          <div className="glass-panel p-3 rounded-lg glow-lime">
            <div className="text-xs text-muted-foreground">Health Score</div>
            <div className="text-lg font-bold text-green-400">87%</div>
          </div>
        </div>
      </CardContent>
    </Card>
  );
};
