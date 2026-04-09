export function getBoundingBox(lat: number, lng: number, radiusKm: number) {
  const earthRadius = 6371

  const latDelta = (radiusKm / earthRadius) * (180 / Math.PI)
  const lngDelta =
    (radiusKm / earthRadius) * (180 / Math.PI) / Math.cos(lat * Math.PI / 180)

  return {
    minLat: lat - latDelta,
    maxLat: lat + latDelta,
    minLng: lng - lngDelta,
    maxLng: lng + lngDelta
  }
}