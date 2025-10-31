interface Sensor {
  id: string;
  lat: number;
  lng: number;
  fillLevel: number;
  odor: number;
  status: "online" | "warning" | "critical";
}

// Calculate Haversine distance between two GPS coordinates in km
const haversineDistance = (lat1: number, lng1: number, lat2: number, lng2: number): number => {
  const R = 6371; // Earth's radius in km
  const dLat = ((lat2 - lat1) * Math.PI) / 180;
  const dLng = ((lng2 - lng1) * Math.PI) / 180;
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos((lat1 * Math.PI) / 180) *
      Math.cos((lat2 * Math.PI) / 180) *
      Math.sin(dLng / 2) *
      Math.sin(dLng / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  return R * c;
};

// ML-inspired priority scoring function
const calculatePriority = (sensor: Sensor): number => {
  let score = 0;
  
  // High fill level is high priority
  score += sensor.fillLevel * 0.6;
  
  // High odor increases priority
  score += sensor.odor * 4;
  
  // Critical status multiplier
  if (sensor.status === "critical") score *= 1.5;
  if (sensor.status === "warning") score *= 1.2;
  
  return score;
};

// Greedy nearest neighbor with ML-based priority scoring
export const optimizeRoute = (sensors: Sensor[], depotLat: number = 26.9124, depotLng: number = 75.7873) => {
  if (sensors.length === 0) return { route: [], totalDistance: 0, estimatedTime: 0 };

  // Filter bins that need collection (>50% full or critical status)
  const needsCollection = sensors.filter(
    (s) => s.fillLevel > 50 || s.status === "critical" || s.status === "warning"
  );

  if (needsCollection.length === 0) {
    return { route: [], totalDistance: 0, estimatedTime: 0, message: "No bins require collection at this time" };
  }

  const unvisited = new Set(needsCollection.map((s) => s.id));
  const route: Sensor[] = [];
  let currentLat = depotLat;
  let currentLng = depotLng;
  let totalDistance = 0;

  // Start from depot and find optimal path
  while (unvisited.size > 0) {
    let bestSensor: Sensor | null = null;
    let bestScore = -Infinity;

    // For each unvisited bin, calculate composite score
    for (const sensor of needsCollection) {
      if (!unvisited.has(sensor.id)) continue;

      const distance = haversineDistance(currentLat, currentLng, sensor.lat, sensor.lng);
      const priority = calculatePriority(sensor);
      
      // Composite score: prioritize high-priority bins that are reasonably close
      // Lower distance is better, higher priority is better
      const score = priority / (distance + 0.5); // +0.5 to avoid division by zero
      
      if (score > bestScore) {
        bestScore = score;
        bestSensor = sensor;
      }
    }

    if (bestSensor) {
      const distance = haversineDistance(currentLat, currentLng, bestSensor.lat, bestSensor.lng);
      totalDistance += distance;
      route.push(bestSensor);
      unvisited.delete(bestSensor.id);
      currentLat = bestSensor.lat;
      currentLng = bestSensor.lng;
    }
  }

  // Return to depot
  totalDistance += haversineDistance(currentLat, currentLng, depotLat, depotLng);

  // Estimate time: average speed 30 km/h in city + 2 min per bin
  const drivingTime = (totalDistance / 30) * 60; // minutes
  const collectionTime = route.length * 2; // 2 min per bin
  const estimatedTime = Math.ceil(drivingTime + collectionTime);

  return {
    route,
    totalDistance: parseFloat(totalDistance.toFixed(2)),
    estimatedTime,
    binsToCollect: route.length,
  };
};
