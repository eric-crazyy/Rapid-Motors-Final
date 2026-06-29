// Modelltérkép: csak az itt felsorolt autókhoz tartozik 3D modell.
export const MODEL_MAP = {
  // oldtimerek
  'Chevelle SS':          '/models/chevrolet_chevelle_ss_454.glb',
  '250 GTO':              '/models/ferrari_250_gto.glb',
  '300SL Gullwing':       '/models/mercedes_300sl.glb',
  '911 Carrera RS 2.7':   '/models/porsche_911.glb',
  'E-Type Series 1':      '/models/jaguar_e_type_series_1.glb',

  // szuperautók
  'Chiron':               '/models/bugatti_chiron.glb',
  'SF90 Stradale':        '/models/ferrari_sf90_stradale.glb',
  'Aventador SVJ':        '/models/lamborghini_aventador_svj.glb',
  '720S':                 '/models/mclaren_720s.glb',
  '918 Spyder':           '/models/porsche_918_spyder.glb',
  'AMG One':              '/models/mercedes-benz_amg_one.glb',
  'Huayra BC':            '/models/pagani_huayra_bc.glb',
  'Gemera':               '/models/koenigsegg_gemera.glb',
  'Valkyrie':             '/models/aston_martin_valkyrie_spider.glb',
  'GT2 RS':               '/models/porsche_911_gt2_rs.glb',
  'Senna':                '/models/mclaren_senna.glb',
  'Revuelto':             '/models/lamborghini_revuelto.glb',
  'Jesko Absolut':        '/models/koenigsegg_jesko_absolut.glb',
  'LaFerrari':            '/models/ferrari_laferrari.glb',
  'Venom F5':             '/models/hennessey_venom_f5_roadster.glb',

  // luxusautók
  'DBX707':               '/models/aston_martin_dbx707.glb',
  'Speedtail':            '/models/mclaren_speedtail.glb',
  'Battista':             '/models/pininfarina_battista.glb',
  'Urus Performante':     '/models/lamborghini_urus_performante.glb',
  'SLS AMG GT':           '/models/mercedes_sls_amg_gt.glb',
};

// Képútvonal összeállítása a gyártó és modellnév alapján
export const getImagePath = (car) =>
  `/images/${car.manufacturer.toLowerCase().replace(/\s+/g, '-')}-${car.name.toLowerCase().replace(/\s+/g, '-')}.jpg`;

// Kategórianevek magyarul
export const huCategoryMap = new Map([
  ['oldtimer', 'Oldtimer'],
  ['supercar', 'Supercar'],
  ['luxury',   'Luxury car'],
]);
