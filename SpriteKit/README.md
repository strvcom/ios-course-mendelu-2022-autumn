# Sample SpriteKit App
This folder contains simple game created with SpriteKit framework.

## Basic terms

### SKScene
The object that represents the scene of content in SpriteKit. It is the root node of all the SpriteKit nodes. To display a scene you will need an `SKView`.
To edit the scene itself, we will use the __scene editor__. The default __anchor point__ for the scene is __X: 0.5, Y: 0.5__.

### What objects we are using?
Objects library contains variety of objects that we can use in the app.
- __Nodes__ - Our __player__, __zombie__ or  in our game we used the __SKSprite Node__ which is a textured 2D node.
  - __Hitbox and hutbox__ - Hitboxes and hurtboxes are specialized collision checks (collision checks allow you to determine when objects come in contact or overlap). A hitbox is usually associated with some form of attack, and describes where that attack is effective. A hurtbox is usually associated with a character (or any other "hittable" object in your game). Whenever the two collide, we consider the attack to have "landed" and we apply its effect on the target.
  - __SKTileMapNode__ - Node used to represent the whole map of the level defined in the `Level1.skc`.


- __Labels__ - Used for our title labels in the welcome, game over or level completed screens.
- __Atlas__ - Is basically an array of `SKTexture` used for each frame of animation.
  - Animation example using atlas:
  ``` js
  // Create the atlas for player idle animation and get its textures
  private let idleFrames = SKTextureAtlas(named: Assets.Atlas.playerIdle).textures
  // Add animation to the list of animations
  animations[Animations.idle.rawValue] = SKAction.repeatForever(
      SKAction.animate(
          with: idleFrames,
          timePerFrame: 0.2,
          resize: false,
          restore: true
      )
  )
  // Reproduce the animation
  // `playanimation` is actually a function in the extension of `AnimatedObject` which depending on the string key,
  // obtains the `SKAction` from the dictionary of animations and runs this action.
  playAnimation(key: Animations.idle.rawValue)
  ```

- __SKCameraNode__ - node that determines which part of the scene is visible to the user. In our case we use the `func update(_ currentTime: TimeInterval)` function which runs repeatedly with each frame. Inside this function we center the camera to the player position.

### Physics
SpriteKit is it comes with a physics engine built right in. It can be used for simulating quite realistic movements and for collision detection. In case that we want our __sprite to detect collision__ we need to __associate a shape__ to it. By doing this, we create a __physics body__.

- __Category bitmask__ - Every physics body in a scene can be assigned to up to __32 different categories__. We use the category mask to detect contacts between different nodes. (In our case we detect if the hurtbox intersects with either zombie or player and determine the result of the battle).
- __Collision bitmask__ - This mask defines which __category bit mask__ may collide with the physics body that has this collision mask set.
- __Contact mask__ - This mask is used to emit intersect notifications when 2 physics bodies shares the same space.
