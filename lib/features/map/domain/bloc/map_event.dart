abstract class MapEvent {
  const MapEvent();
}

class MapEventLoad extends MapEvent {
  const MapEventLoad();
}

class MapEventLoadCampusLocations extends MapEvent {
  const MapEventLoadCampusLocations();
}

class MapEventUpdateCurrentLocation extends MapEvent {
  const MapEventUpdateCurrentLocation();
}
