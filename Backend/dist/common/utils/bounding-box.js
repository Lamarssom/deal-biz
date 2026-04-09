"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getBoundingBox = getBoundingBox;
function getBoundingBox(lat, lng, radiusKm) {
    const earthRadius = 6371;
    const latDelta = (radiusKm / earthRadius) * (180 / Math.PI);
    const lngDelta = (radiusKm / earthRadius) * (180 / Math.PI) / Math.cos(lat * Math.PI / 180);
    return {
        minLat: lat - latDelta,
        maxLat: lat + latDelta,
        minLng: lng - lngDelta,
        maxLng: lng + lngDelta
    };
}
//# sourceMappingURL=bounding-box.js.map