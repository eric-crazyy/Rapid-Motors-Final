import { ref } from 'vue';
import * as THREE from 'three';
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls';
import { RoomEnvironment } from 'three/examples/jsm/environments/RoomEnvironment.js';
import { MODEL_MAP } from './CarData.js';

const DEFAULT_CAMERA = { x: 1.5, y: 0.8, z: 2.5, tx: 0, ty: 0.3, tz: 0 };

const MODEL_CAMERA_POS = {
  '300SL Gullwing': { x: 2.5, y: 0.8, z: -1.8, tx: 0, ty: 0.3, tz: 0 },
  '720S':           { x: -2.5, y: 0.8, z: 1.8,  tx: 0, ty: 0.3, tz: 0 },
};

export function use3DViewer(viewerContainer) {
  const viewerState       = ref('idle');
  const isHoveringViewer  = ref(false);
  const cursorX           = ref(0);
  const cursorY           = ref(0);
  const cursorDirection   = ref('idle');
  const showRotateHint    = ref(false);

  let scene, camera, renderer, controls, animationId, resizeHandler;
  let isRotating = false;
  let hintTimer = null;
  let dirResetTimer = null;
  let prevMouseX = 0, prevMouseY = 0;

  let loadGeneration = 0;

  const showHintSoon = (delay = 900) => {
    clearTimeout(hintTimer);
    hintTimer = setTimeout(() => { showRotateHint.value = true; }, delay);
  };

  const handleViewerMouseMove = (e) => {
    if (!viewerContainer.value) return;
    const rect = viewerContainer.value.getBoundingClientRect();
    cursorX.value = e.clientX - rect.left - 20;
    cursorY.value = e.clientY - rect.top - 20;
    if (!isRotating) { prevMouseX = e.clientX; prevMouseY = e.clientY; return; }
    const dx = Math.abs(e.clientX - prevMouseX);
    const dy = Math.abs(e.clientY - prevMouseY);
    prevMouseX = e.clientX; prevMouseY = e.clientY;
    if (dx > 0.5 || dy > 0.5) {
      if (dx > dy * 2.2)      cursorDirection.value = 'h';
      else if (dy > dx * 2.2) cursorDirection.value = 'v';
      else                    cursorDirection.value = 'both';
    }
    clearTimeout(dirResetTimer);
    dirResetTimer = setTimeout(() => { cursorDirection.value = 'idle'; }, 80);
  };

  const onRotateStart = (e) => {
    if (e.button !== 0) return;
    isRotating = true;
    showRotateHint.value = false;
    clearTimeout(hintTimer);
  };

  const onRotateEnd = (e) => {
    if (e.button !== 0) return;
    isRotating = false;
    clearTimeout(dirResetTimer);
    cursorDirection.value = 'idle';
    showHintSoon(900);
  };

  const onViewerMouseLeave = () => {
    isHoveringViewer.value = false;
    isRotating = false;
    cursorDirection.value = 'idle';
    clearTimeout(dirResetTimer);
    showHintSoon(900);
  };

  const cleanup3DViewer = () => {
    if (resizeHandler) { window.removeEventListener('resize', resizeHandler); resizeHandler = null; }
    if (animationId)   { cancelAnimationFrame(animationId); animationId = null; }
    if (renderer) {
      renderer.dispose();
      if (viewerContainer.value && renderer.domElement?.parentNode === viewerContainer.value)
        viewerContainer.value.removeChild(renderer.domElement);
      renderer = null;
    }
    if (scene) {
      scene.traverse(obj => {
        if (obj.geometry) obj.geometry.dispose();
        if (obj.material) (Array.isArray(obj.material) ? obj.material : [obj.material]).forEach(m => m.dispose());
      });
      scene = null;
    }
    controls = null;
    camera   = null;
  };

  const init3DViewer = async (carName) => {
    if (!viewerContainer.value) return;
    cleanup3DViewer();

    const myGeneration = ++loadGeneration;

    const modelUrl = MODEL_MAP[carName] ?? null;
    if (!modelUrl) { viewerState.value = 'unavailable'; return; }
    viewerState.value = 'loading';

    const container = viewerContainer.value;
    const w = container.clientWidth;
    const h = container.clientHeight;
    const cam = MODEL_CAMERA_POS[carName] ?? DEFAULT_CAMERA;

    scene = new THREE.Scene();
    scene.background = new THREE.Color(0x0f0f0f);
    scene.fog = new THREE.Fog(0x0f0f0f, 10, 60);

    camera = new THREE.PerspectiveCamera(45, w / h, 0.1, 1000);
    camera.position.set(cam.x, cam.y, cam.z);

    renderer = new THREE.WebGLRenderer({ antialias: true, alpha: true });
    renderer.setSize(w, h);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
    renderer.outputColorSpace    = THREE.SRGBColorSpace;
    renderer.toneMapping         = THREE.ACESFilmicToneMapping;
    renderer.toneMappingExposure = 1.0;
    renderer.shadowMap.enabled   = true;
    renderer.shadowMap.type      = THREE.PCFSoftShadowMap;
    renderer.domElement.style.cssText = 'display:block;width:100%;height:100%;';
    container.appendChild(renderer.domElement);

    const pmrem = new THREE.PMREMGenerator(renderer);
    pmrem.compileEquirectangularShader();
    scene.environment = pmrem.fromScene(new RoomEnvironment(), 0.04).texture;

    const spotLight = new THREE.SpotLight(0xffffff, 20);
    spotLight.position.set(0, 5, 0);
    spotLight.angle    = Math.PI / 4;
    spotLight.penumbra = 0.8;
    spotLight.castShadow = true;
    spotLight.shadow.mapSize.width  = 1024;
    spotLight.shadow.mapSize.height = 1024;
    spotLight.shadow.bias = -0.0001;
    scene.add(spotLight);

    const ground = new THREE.Mesh(
      new THREE.PlaneGeometry(500, 500),
      new THREE.ShadowMaterial({ opacity: 0.6 })
    );
    ground.rotation.x    = -Math.PI / 2;
    ground.receiveShadow = true;
    scene.add(ground);

    const grid = new THREE.GridHelper(500, 1000, 0xc9a961, 0xffffff);
    grid.material.opacity    = 0.05;
    grid.material.transparent = true;
    scene.add(grid);

    controls = new OrbitControls(camera, renderer.domElement);
    controls.enableDamping  = true;
    controls.dampingFactor  = 0.05;
    controls.enableZoom     = false;
    controls.enablePan      = false;
    controls.target.set(cam.tx, cam.ty, cam.tz);
    controls.autoRotate     = false;
    controls.minPolarAngle  = 0.05;
    controls.maxPolarAngle  = Math.PI / 2 - 0.02;

    try {
      const gltf = await new GLTFLoader().loadAsync(modelUrl);

      if (myGeneration !== loadGeneration) return;

      const model = gltf.scene;
      const box    = new THREE.Box3().setFromObject(model);
      const size   = box.getSize(new THREE.Vector3());
      const center = box.getCenter(new THREE.Vector3());
      const scale  = 2.5 / Math.max(size.x, size.y, size.z);
      model.scale.multiplyScalar(scale);
      model.position.sub(center.multiplyScalar(scale));
      model.position.y = 0;
      model.traverse(child => {
        if (child.isMesh) {
          child.castShadow    = true;
          child.receiveShadow = true;
          if (child.material) {
            child.material.envMapIntensity = 1.5;
            child.material.needsUpdate     = true;
          }
        }
      });
      scene.add(model);

      viewerState.value = 'loaded';
      showHintSoon(800);

      const animate = () => {
        animationId = requestAnimationFrame(animate);
        controls.update();
        renderer.render(scene, camera);
      };
      animate();

    } catch (err) {

      if (myGeneration !== loadGeneration) return;

      console.error('3D model load error:', err);
      viewerState.value = 'unavailable';
      cleanup3DViewer();
      return;
    }

    resizeHandler = () => {
      if (!viewerContainer.value || !renderer || !camera) return;
      const nw = viewerContainer.value.clientWidth;
      const nh = viewerContainer.value.clientHeight;
      if (!nw || !nh) return;
      camera.aspect = nw / nh;
      camera.updateProjectionMatrix();
      renderer.setSize(nw, nh, false);
    };
    window.addEventListener('resize', resizeHandler);
  };

  const destroyViewer = () => {
    loadGeneration++;
    cleanup3DViewer();
    clearTimeout(dirResetTimer);
    clearTimeout(hintTimer);
    showRotateHint.value = false;
  };

  return {
    viewerState, isHoveringViewer, cursorX, cursorY,
    cursorDirection, showRotateHint,
    init3DViewer, destroyViewer, showHintSoon,
    handleViewerMouseMove, onRotateStart, onRotateEnd, onViewerMouseLeave,
  };
}
