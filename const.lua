return {
  state = {
    disconnect = 0,
    connecting = 1,
    connected = 2
  },
  -- see players[1].state
  gameState = {
    warmup = 0,
    active = 1,
    roundPrepare = 2,
    roundActive = 3,
    roundCooldownSomeoneWon = 4,
    roundCooldownDraw = 5,
    gameover = 6
  },
  -- see world.gameState
  playerState = {
    ingame = 1,
    spectator = 2,
    editor = 3,
    queued = 4
  },
  -- see pickupTimers[1].type
  pickupType = {
    burstGun = 0,
    shotgun = 1,
    grenadeLauncher = 2,
    machineGun = 3,
    rocketLauncer = 4,
    ionCannon = 5,
    boltRifle = 6,
    stakeGun = 7,

    health5 = 40,
    health25 = 41,
    health50 = 42,
    health100 = 43,

    armor5 = 50,
    armor50 = 51,
    armor100 = 52,
    armor150 = 53,

    powerupCarnage = 60
  },

  font = {
    header = "oswald-bold";
    hud = "oswald-bold";
    text = "roboto-regular";
    textBold = "roboto-bold";
    sizeDefault = 24;
    sizeSmall = 22;
  }
}
