import { Card } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";

interface Sensor {
  id: string;
  lat: number;
  lng: number;
  fillLevel: number;
  odor: number;
  status: "online" | "warning" | "critical";
}

interface BinStatusTableProps {
  sensors: Sensor[];
}

export const BinStatusTable = ({ sensors }: BinStatusTableProps) => {
  // Show only critical and warning bins
  const priorityBins = sensors
    .filter((s) => s.status === "critical" || s.status === "warning")
    .sort((a, b) => b.fillLevel - a.fillLevel)
    .slice(0, 8);

  const getStatusBadge = (status: string) => {
    switch (status) {
      case "critical":
        return <Badge variant="destructive" className="text-xs">Critical</Badge>;
      case "warning":
        return <Badge variant="outline" className="text-xs border-yellow-600 text-yellow-600">Warning</Badge>;
      default:
        return <Badge variant="outline" className="text-xs">Online</Badge>;
    }
  };

  const getLastCollection = (index: number) => {
    const hours = 12 + (index * 3);
    return `${hours}h ago`;
  };

  return (
    <Card className="col-span-1 lg:col-span-2 gov-card">
      <div className="p-6">
        <div className="flex items-center justify-between mb-4">
          <h2 className="text-xl font-bold text-gov-title">Priority Collection Queue</h2>
          <Badge variant="outline" className="text-xs">{priorityBins.length} Bins</Badge>
        </div>
        
        <div className="overflow-x-auto">
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>Bin ID</TableHead>
                <TableHead>Fill Level</TableHead>
                <TableHead>Odor Index</TableHead>
                <TableHead>Status</TableHead>
                <TableHead>Last Collection</TableHead>
                <TableHead>Coordinates</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {priorityBins.map((sensor, index) => (
                <TableRow key={sensor.id}>
                  <TableCell className="font-medium">{sensor.id}</TableCell>
                  <TableCell>
                    <div className="flex items-center gap-2">
                      <div className="w-20 h-2 bg-muted rounded-full overflow-hidden">
                        <div
                          className={`h-full transition-all ${
                            sensor.fillLevel > 85
                              ? "bg-destructive"
                              : sensor.fillLevel > 60
                              ? "bg-yellow-600"
                              : "bg-primary"
                          }`}
                          style={{ width: `${sensor.fillLevel}%` }}
                        />
                      </div>
                      <span className="text-xs font-medium">{sensor.fillLevel}%</span>
                    </div>
                  </TableCell>
                  <TableCell>
                    <span className={`text-xs font-medium ${
                      sensor.odor > 7 ? "text-destructive" : 
                      sensor.odor > 4 ? "text-yellow-600" : 
                      "text-muted-foreground"
                    }`}>
                      {sensor.odor}/10
                    </span>
                  </TableCell>
                  <TableCell>{getStatusBadge(sensor.status)}</TableCell>
                  <TableCell className="text-xs text-muted-foreground">
                    {getLastCollection(index)}
                  </TableCell>
                  <TableCell className="text-xs text-muted-foreground font-mono">
                    {sensor.lat.toFixed(4)}, {sensor.lng.toFixed(4)}
                  </TableCell>
                </TableRow>
              ))}
            </TableBody>
          </Table>
        </div>
      </div>
    </Card>
  );
};
