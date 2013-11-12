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

  def touchesEnded(touches, withEvent: event)
    location = touches.anyObject.locationInNode(self)

    screen_size = self.frame.size
    bear_velocity = screen_size.width / 3.0

    move_difference = CGPointMake(location.x - @bear.position.x, location.y - @bear.position.y)
    distance_to_move = Math.sqrt(move_difference.x * move_difference.x + move_difference.y * move_difference.y)
    move_duration = distance_to_move / bear_velocity

    if move_difference.x < 0
      multiplier_for_direction = 1
    else
      multiplier_for_direction = -1
    end
    @bear.xScale = @bear.xScale.abs * multiplier_for_direction

    if @bear.actionForKey("bearMoving")
      # Changing Animation Facing Direction Based on Movement
      @bear.removeActionForKey("bearMoving")
    end

    if !@bear.actionForKey("walkingInPlaceBear")
      # if legs are not moving go ahead and start them
      self.walking_bear
    end

    move_action = SKAction.moveTo(location, duration: move_duration)
    done_action = SKAction.runBlock(lambda {
      puts "Animation Completed"
      self.bear_move_ended
    })

    move_action_with_done = SKAction.sequence([move_action, done_action])
    @bear.runAction(move_action_with_done, withKey: "bearMoving")
  end

  def touchesBegan(touches, withEvent: event)
  end

  def bear_move_ended
    @bear.removeAllActions
  end

  def update(current_time)
    # Called before each frame is rendered
  end
end
