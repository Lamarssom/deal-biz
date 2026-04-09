"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateHaversineDistance = void 0;
exports.calculateHaversineDistance = {
    js(lat1, lon1, lat2, lon2) {
        const R = 6371;
        const dLat = (lat2 - lat1) * Math.PI / 180;
        const dLon = (lon2 - lon1) * Math.PI / 180;
        const a = Math.sin(dLat / 2) * Math.sin(dLat / 2) +
            Math.cos(lat1 * Math.PI / 180) *
                Math.cos(lat2 * Math.PI / 180) *
                Math.sin(dLon / 2) * Math.sin(dLon / 2);
        const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
        return R * c;
    },
    sql: `
    6371 * acos(
      cos(radians($7)) *
      cos(radians(latitude)) *
      cos(radians(longitude) - radians($8)) +
      sin(radians($7)) *
      sin(radians(latitude))
    )
  `
};
//# sourceMappingURL=haversine.js.map