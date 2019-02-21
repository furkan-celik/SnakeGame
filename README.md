# SnakeGame

Gameplay video of game = https://youtu.be/1fQRiSdUKWk

I made that game within 3 days of I got a macbook. Fastest idea to do was snake game but I did not want to do standard snake game. There is 3 enemy types added in this version. Standard enemy plays like player and competes with player, second enemy just able to go cross ways and it is a little dumb. And the third enemy is predator which aims to kill player before player kills it. When player eats itself in half, one of these three snakes spawns randomly and starts to play. Eating enemy in half and/or enemy's eating each other in half makes the same effect aswell. However, especially predator snake is very buggy, in sort period of time I could accomplish this much with learning swift and sprite kit of swift in remained time from my work.

![main screen](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h06m17s769.png)
You can see my games main screen in this picture. Main screen is very simple and easy to join game with one tab

![game state](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h06m37s046.png)
You can see my game state at this picture. Main playground is centered in screen to capture player's eyes easily and only texts are high score of player and score of player. Player scores increases 1 for every meal and half of the enemy size after eating enemy.

![portals in game](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h06m47s488.png)
Portals are randomly spawning in places player is not present. They are working in both ways of teleporting player one to another. In my plans if portal expires while player teleporting, the enemy would spawn but I could not find convient way to inform player about remained time of portal so I did not implemented that feature.

![dumb enemy](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h07m02s788.png)
This is our dumb enemy. It is just moves cross ways and when it reaches to the end of the map it destroys itself.

![standard enemy](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h07m42s351.png)
This is our standard enemy. This one plays like player and mostly beats player by growing faster than player. But the aim of this snake is not attacking player.

![head bite enemy](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h07m51s607.png)
In this case of collusion, player will wipe out enemy because of bite of player is to one of the first 3 blocks of enemy. I insprired by nature of snake, in nature cutting snake in half creates almost 2 snake and cutting from head kills snake, so I added this as a feature to both player and enemy. If player eats itself between its first 5 block, player dies; after 5th block remaining part of body will generate new snake which will be an enemy to player.

![head bite enemy](https://raw.githubusercontent.com/furkan-celik/SnakeGame/master/photos/vlcsnap-2019-02-21-18h08m25s896.png)
In this case of collusion, player will create 2 enemy snakes because of biting enemy snake to half.
