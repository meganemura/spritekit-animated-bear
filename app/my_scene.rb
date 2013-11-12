class MyScene < SKScene

  attr_accessor :bear
  attr_accessor :bear_walking_frames

  def initWithSize(size)
    super

    self.backgroundColor = SKColor.blackColor

    walk_frames = []
    bear_animated_atlas = SKTextureAtlas.atlasNamed("BearImages")

    num_images = bear_animated_atlas.textureNames.count
    (1..num_images/2).each do |n|
      texture_name = "bear#{n}"
      temp = bear_animated_atlas.textureNamed(texture_name)
      walk_frames.addObject(temp)
    end
    @bear_walking_frames = walk_frames

    temp = @bear_walking_frames.first
    @bear = SKSpriteNode.spriteNodeWithTexture(temp)
    @bear.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame))
    self.addChild(@bear)
    self.walking_bear

    self
  end

  def walking_bear
    @bear.runAction(
      SKAction.repeatActionForever(
        SKAction.animateWithTextures(
          @bear_walking_frames,
          timePerFrame: 0.1,
          resize: false,
          restore: true
        )
      ),
      withKey: "walkingInPlaceBear"
    )
  end

  def update(current_time)
    # Called before each frame is rendered
  end
end
