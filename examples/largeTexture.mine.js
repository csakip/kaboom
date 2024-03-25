document.body.style.overflow = "hidden";
kaboom({ background: [0, 0, 0] });

let cameraPosition = camPos();
let cameraScale = 1;
let gridOffset = vec2(0, 0);

loadShaderURL("grid", null, "/examples/largeTextureFrag.glsl");

// Loads a random 2500px image
loadSprite(
  "large-image",
  "https://images.squarespace-cdn.com/content/v1/62750da488ff573e9bdc63c4/abd01574-7009-44d3-b717-e9c9ddf31445/TC_Thestwick+Watch+Ruins+04+Lookout+Lair_No+Grid_44x34.jpg"
);
console.log("cameraPosition", cameraPosition);
add([
  sprite("large-image"),
  shader("grid", () => ({
    u_scale: cameraScale,
    u_offset: toScreen(gridOffset),
  })),
]);

// Mouse handling
onUpdate(() => {
  if (isMouseDown("left") && isMouseMoved()) {
    cameraPosition = cameraPosition.sub(mouseDeltaPos().scale(1 / cameraScale));
    camPos(cameraPosition);
  }
});

onScroll((delta) => {
  let scaleFactor = 0.85;
  if (delta.y < 0) {
    scaleFactor = 1 / scaleFactor;
  }

  const mouseWorldPos = toWorld(mousePos());
  const deltaPos = cameraPosition.sub(mouseWorldPos);
  const newDeltaPos = deltaPos.scale(1 / scaleFactor);
  cameraPosition = cameraPosition.sub(deltaPos.sub(newDeltaPos));

  camPos(cameraPosition);
  cameraScale = cameraScale * scaleFactor;
  camScale(cameraScale);
});
