export const calculateHaversineDistance = {
  sql: `
    6371 * acos(
      cos(radians(:userLat)) *
      cos(radians(latitude)) *
      cos(radians(longitude) - radians(:userLng)) +
      sin(radians(:userLat)) *
      sin(radians(latitude))
    )
  `,
  js: (lat1: number, lon1: number, lat2: number, lon2: number) => {
    const R = 6371;
    const dLat = ((lat2 - lat1) * Math.PI) / 180;
    const dLon = ((lon2 - lon1) * Math.PI) / 180;

    const a =
      Math.sin(dLat / 2) * Math.sin(dLat / 2) +
      Math.cos((lat1 * Math.PI) / 180) *
        Math.cos((lat2 * Math.PI) / 180) *
        Math.sin(dLon / 2) *
        Math.sin(dLon / 2);

    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
    return R * c;
  },
};