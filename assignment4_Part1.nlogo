; UVA/VU - Multi-Agent Systems
; Lecturers: T. Bosse & M.C.A. Klein
; Lab assistants: D. Formolo & L. Medeiros


; --- Assignment 4.1 - Template ---
; Please use this template as a basis for the code to generate the behaviour of your team of vacuum cleaners.
; However, feel free to extend this with any variable or method you think is necessary.


; --- Settable variables ---
; The following settable variables are given as part of the 'Interface' (hence, these variables do not need to be declared in the code):
;
; 1) dirt_pct: this variable represents the percentage of dirty cells in the environment.
;
; 2) num_agents: number of vacuum cleaner agents in the simularion.
;
; 3) vision_radius: distance (in terms of number of cells) that the agents can 'see'
; For instance, if this radius is 3, then agents will be able to observe dirt in a cell that is 3 cells away from their own location.


; --- Global variables ---
; The following global variables are given.
;
; 1) total_dirty: this variable represents the amount of dirty cells in the environment.
; 2) time: the total simulation time.
globals [total_dirty time color_list stopped]


; --- Agents ---
; The following types of agent (called 'breeds' in NetLogo) are given.
;
; 1) vacuums: vacuum cleaner agents.
breed [vacuums vacuum]


; --- Local variables ---
; The following local variables are given.
;
; 1) beliefs: the agent's belief base about locations that contain dirt
; 2) desire: the agent's current desire
; 3) intention: the agent's current intention
; 4) own_color: the agent's belief about its own target color
vacuums-own [beliefs desire intention own_color]


; --- Setup ---
to setup
  clear-all

  set time 0

  set color_list n-of num_agents [yellow green blue red pink brown grey]
  setup-patches
  setup-vacuums
  setup-ticks
  reset-timer
end


; --- Main processing cycle ---
to go

  ; This method executes the main processing cycle of an agent.
  ; For Assignment 4.1, this involves updating desires, beliefs and intentions, and executing actions (and advancing the tick counter).

  update-desires
  update-beliefs
  update-intentions
  execute-actions
  visio-cones
  tick
end


; --- Setup patches ---
to setup-patches
  ; In this method you may create the environment (patches), using colors to define cells with various types of dirt.
  set total_dirty  ( dirt_pct / 100 * 25 * 25 )
  ask n-of total_dirty patches [set pcolor one-of color_list]
end


; --- Setup vacuums ---
to setup-vacuums
  ; In this method you may create the vacuum cleaner agents.
  create-vacuums num_agents [
   setxy (( random 25) - 12 ) ((random 25) - 12)]
   ask vacuums [
   set beliefs []
   foreach (n-values num_agents [?]) [ask vacuum ?
     [set color item ? color_list
       set own_color color ]]
   let oc own_color
    ask patches in-cone-nowrap (vision_radius / 100 * 12) 360
   [
    set plabel-color oc
     set plabel "*"
    ]
   ]

end


; --- Setup ticks ---
to setup-ticks
  ; In this method you may start the tick counter.
  reset-ticks
end


; --- Update desires ---
to update-desires
  ; You should update your agent's desires here.
  ; Keep in mind that now you have more than one agent.
  foreach (n-values num_agents [?]) [ask vacuum ? [set desire (count patches with [pcolor = (item ? color_list)])]]
end


; --- Update beliefs ---
to update-beliefs
 ; You should update your agent's beliefs here.
 ; Please remember that you should use this method whenever your agents changes its position.

 ask vacuums [
   let pc own_color
   let newBelief ((patches in-cone-nowrap (vision_radius / 100 * 12) 360) with [pcolor = pc])
   let oldBelief beliefs
   let n (patch-set newBelief oldBelief)
   set beliefs n
 ]

end


; --- Update intentions ---
to update-intentions
  ; You should update your agent's intentions here.
  ask vacuums [
    ifelse beliefs != []
    [
    set intention (min-one-of beliefs [distance myself] )
    ]
    [
      set intention nobody
    ]
  ]
end

to visio-cones

  ask patches [ set plabel ""]

  ask vacuums[
    let oc own_color
  ask patches in-cone-nowrap (vision_radius / 100 * 12) 360
   [
    set plabel-color oc
     set plabel "8"
    ]

  ]
end
; --- Execute actions ---
to execute-actions
  ; Here you should put the code related to the actions performed by your agent: moving, cleaning, and (actively) looking around.
  ; Please note that your agents should perform only one action per tick!
  ask vacuums [

    if (pcolor = own_color)
    [
      set pcolor black
      set beliefs sort beliefs
      set beliefs remove intention beliefs
    ]

    ifelse (intention != nobody)
    [
      ifelse (desire != 0)
    [
      face intention
    forward 1
    ]
    [
      stop
      set stopped stopped + 1
    ]
    ]
    [
      ifelse (desire != 0)
      [
        ifelse can-move? 1
        [
          forward 1
        ]
        [
      facexy (( random 25) - 12 ) ((random 25) - 12)
        ]
      ]
      [
        stop
        set stopped stopped + 1
      ]
    ]


  ]
  if (stopped != num_agents)
  [
  set time timer
  ]
end
@#$#@#$#@
GRAPHICS-WINDOW
786
17
1171
423
12
12
15.0
1
10
1
1
1
0
0
0
1
-12
12
-12
12
1
1
1
ticks
30.0

SLIDER
9
118
775
151
dirt_pct
dirt_pct
0
100
9
1
1
NIL
HORIZONTAL

BUTTON
9
86
393
119
NIL
go
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
392
86
775
119
NIL
go
T
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

BUTTON
9
229
775
262
NIL
setup
NIL
1
T
OBSERVER
NIL
NIL
NIL
NIL
1

SLIDER
9
155
775
188
num_agents
num_agents
2
7
2
1
1
NIL
HORIZONTAL

SLIDER
8
192
775
225
vision_radius
vision_radius
0
100
100
1
1
NIL
HORIZONTAL

MONITOR
9
349
775
394
Intention of vacuum 1
[intention] of vacuum 0
17
1
11

MONITOR
9
393
775
438
Desire of vacuum 1
[desire] of vacuum 0
17
1
11

MONITOR
9
305
775
350
Beliefs of vacuum 1
[beliefs] of vacuum 0
17
1
11

MONITOR
10
497
776
542
Beliefs of vacuum 2
[beliefs] of vacuum 1
17
1
11

MONITOR
9
262
775
307
Color of vacuum 1
[own_color] of vacuum 0
17
1
11

MONITOR
10
453
776
498
Color of vacuum 2
[own_color] of vacuum 1
17
1
11

MONITOR
10
541
776
586
Intention of vacuum 2
[intention] of vacuum 1
17
1
11

MONITOR
10
585
776
630
Desire of vacuum 2
[desire] of vacuum 1
17
1
11

MONITOR
11
642
777
687
Color of vacuum 3
[own_color] of vacuum 2
17
1
11

MONITOR
11
686
777
731
Beliefs of vacuum 3
[beliefs] of vacuum 2
17
1
11

MONITOR
11
730
777
775
Intention of vacuum 3
[intention] of vacuum 2
17
1
11

MONITOR
11
774
777
819
Desire of vacuum 3
[desire] of vacuum 2
17
1
11

MONITOR
9
18
775
63
Time to complete the task.
time
17
1
11

@#$#@#$#@
## WHAT IS IT?

This model explores the behavior of multiple smart vacuum cleaners with beliefs, desires and intentions. They all have the desire to clean all the dirts matching their colours in the environment. Each of the agents have a vision cone, which denotes the distance and the area it can see. The agents can know of only the dirts within their respective vision range. The agents can only clean dust that is of the same colours as them. The agents have the desire to clean all the dirt in the environment. They stop as soon as the last dirt corresponding to their colour has been cleaned. The agents do not communicate with each other. They move in a random direction, if they can't see any dirt in their vision radius, till they hit a wall after which they randomly change their direction.

## HOW IT WORKS

Each of the vacuum sets up its own beliefs about the location of the corresponding coloured dirts within its vision cones. They also update their desires as a list of locations of all the same coloured dirts in the entire environment. The vacuums will always move to the nearest corresponding coloured dirt that is on their belief bases and clean it. Onece all of the corresponding coloured dirts have been cleaned, the desire of the vacuums is satisfied and thus they stop. The intentions of the vacuum cleaners at any given time are the nearest dirt cells on their belief bases.

## HOW TO USE IT
Slider dirt_pct: Sets the dirt percent for the world
Button setup: Sets up the world with the initial values defined in the function setup Button go: This triggers the agent code to run.
Slider vision_radius: This is the percentage of the world that the agent can see
Slider num_agents: This is the number of vacuum cleaners that will be spawned.

1) Set the dirt percent with the slider.
2) Set the vision radius with the slider.
3) Set the number of agents to be spawned with the slider.
4) Setup the world with the setup button.
5) Execute the model by pressing the go button on the right side. To see how the vacuum behave in a single step, press the go button on the left side.



## THINGS TO NOTICE

The details of the first 3 vacuums are tracked with the following monitors. All of the vacuums are not tracked because of space constraints.
The colour of the vacuum is tracked in the monitor named the colour of vacuum. It is an in-built netlogo constant so it shows up as a number. It can be checked by inspecting the desired vacuum in the netlogo world monitor.
The monitor named Beliefs of the Vacuum shows the set of patches that the particular vacuum believes to be dirty, that is contains the same coloured dirts as itself, within it's vision range.
The monitor named Intention of the Vacuum shows the coordinates of the nearest dirty cell of the same colour within it's vision range.
The monitor named Desire of the Vacuum shows the count of the total number of dirty cells of the same colour as the agent in the world. The agent stops as soon as the desire reaches zero.
Each agent has their own vision cones represented by the same colour.


## THINGS TO TRY

The dirt percentage can be modified by using the slider labelled dirt_pct.
The vision cone and number of agents can be modified by using the slider labelled vision_radius and num_agents, respectively.
The execution time reduces as the different values are varied. If the vision is made 100%, then the entire world is visible and so there is no need for exploration. Increasing the dirt amount too reduces the random walk required, because most of the dirt has a higher of being "spotted" while moving to clean other dust and thus be added to it's belief base. Thus the execution time decreseases even when the vision radius is comparatively small, and thus random exploration is reduced.
Random exploration adds to the execution time.


## CREDITS
Shuai Wang (11108339)
 Kaixin Hu (11129417)
Partha Das (11137053)
@#$#@#$#@
default
true
0
Polygon -7500403 true true 150 5 40 250 150 205 260 250

airplane
true
0
Polygon -7500403 true true 150 0 135 15 120 60 120 105 15 165 15 195 120 180 135 240 105 270 120 285 150 270 180 285 210 270 165 240 180 180 285 195 285 165 180 105 180 60 165 15

arrow
true
0
Polygon -7500403 true true 150 0 0 150 105 150 105 293 195 293 195 150 300 150

box
false
0
Polygon -7500403 true true 150 285 285 225 285 75 150 135
Polygon -7500403 true true 150 135 15 75 150 15 285 75
Polygon -7500403 true true 15 75 15 225 150 285 150 135
Line -16777216 false 150 285 150 135
Line -16777216 false 150 135 15 75
Line -16777216 false 150 135 285 75

bug
true
0
Circle -7500403 true true 96 182 108
Circle -7500403 true true 110 127 80
Circle -7500403 true true 110 75 80
Line -7500403 true 150 100 80 30
Line -7500403 true 150 100 220 30

butterfly
true
0
Polygon -7500403 true true 150 165 209 199 225 225 225 255 195 270 165 255 150 240
Polygon -7500403 true true 150 165 89 198 75 225 75 255 105 270 135 255 150 240
Polygon -7500403 true true 139 148 100 105 55 90 25 90 10 105 10 135 25 180 40 195 85 194 139 163
Polygon -7500403 true true 162 150 200 105 245 90 275 90 290 105 290 135 275 180 260 195 215 195 162 165
Polygon -16777216 true false 150 255 135 225 120 150 135 120 150 105 165 120 180 150 165 225
Circle -16777216 true false 135 90 30
Line -16777216 false 150 105 195 60
Line -16777216 false 150 105 105 60

car
false
0
Polygon -7500403 true true 300 180 279 164 261 144 240 135 226 132 213 106 203 84 185 63 159 50 135 50 75 60 0 150 0 165 0 225 300 225 300 180
Circle -16777216 true false 180 180 90
Circle -16777216 true false 30 180 90
Polygon -16777216 true false 162 80 132 78 134 135 209 135 194 105 189 96 180 89
Circle -7500403 true true 47 195 58
Circle -7500403 true true 195 195 58

circle
false
0
Circle -7500403 true true 0 0 300

circle 2
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240

cow
false
0
Polygon -7500403 true true 200 193 197 249 179 249 177 196 166 187 140 189 93 191 78 179 72 211 49 209 48 181 37 149 25 120 25 89 45 72 103 84 179 75 198 76 252 64 272 81 293 103 285 121 255 121 242 118 224 167
Polygon -7500403 true true 73 210 86 251 62 249 48 208
Polygon -7500403 true true 25 114 16 195 9 204 23 213 25 200 39 123

cylinder
false
0
Circle -7500403 true true 0 0 300

dot
false
0
Circle -7500403 true true 90 90 120

face happy
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 255 90 239 62 213 47 191 67 179 90 203 109 218 150 225 192 218 210 203 227 181 251 194 236 217 212 240

face neutral
false
0
Circle -7500403 true true 8 7 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Rectangle -16777216 true false 60 195 240 225

face sad
false
0
Circle -7500403 true true 8 8 285
Circle -16777216 true false 60 75 60
Circle -16777216 true false 180 75 60
Polygon -16777216 true false 150 168 90 184 62 210 47 232 67 244 90 220 109 205 150 198 192 205 210 220 227 242 251 229 236 206 212 183

fish
false
0
Polygon -1 true false 44 131 21 87 15 86 0 120 15 150 0 180 13 214 20 212 45 166
Polygon -1 true false 135 195 119 235 95 218 76 210 46 204 60 165
Polygon -1 true false 75 45 83 77 71 103 86 114 166 78 135 60
Polygon -7500403 true true 30 136 151 77 226 81 280 119 292 146 292 160 287 170 270 195 195 210 151 212 30 166
Circle -16777216 true false 215 106 30

flag
false
0
Rectangle -7500403 true true 60 15 75 300
Polygon -7500403 true true 90 150 270 90 90 30
Line -7500403 true 75 135 90 135
Line -7500403 true 75 45 90 45

flower
false
0
Polygon -10899396 true false 135 120 165 165 180 210 180 240 150 300 165 300 195 240 195 195 165 135
Circle -7500403 true true 85 132 38
Circle -7500403 true true 130 147 38
Circle -7500403 true true 192 85 38
Circle -7500403 true true 85 40 38
Circle -7500403 true true 177 40 38
Circle -7500403 true true 177 132 38
Circle -7500403 true true 70 85 38
Circle -7500403 true true 130 25 38
Circle -7500403 true true 96 51 108
Circle -16777216 true false 113 68 74
Polygon -10899396 true false 189 233 219 188 249 173 279 188 234 218
Polygon -10899396 true false 180 255 150 210 105 210 75 240 135 240

house
false
0
Rectangle -7500403 true true 45 120 255 285
Rectangle -16777216 true false 120 210 180 285
Polygon -7500403 true true 15 120 150 15 285 120
Line -16777216 false 30 120 270 120

leaf
false
0
Polygon -7500403 true true 150 210 135 195 120 210 60 210 30 195 60 180 60 165 15 135 30 120 15 105 40 104 45 90 60 90 90 105 105 120 120 120 105 60 120 60 135 30 150 15 165 30 180 60 195 60 180 120 195 120 210 105 240 90 255 90 263 104 285 105 270 120 285 135 240 165 240 180 270 195 240 210 180 210 165 195
Polygon -7500403 true true 135 195 135 240 120 255 105 255 105 285 135 285 165 240 165 195

line
true
0
Line -7500403 true 150 0 150 300

line half
true
0
Line -7500403 true 150 0 150 150

pentagon
false
0
Polygon -7500403 true true 150 15 15 120 60 285 240 285 285 120

person
false
0
Circle -7500403 true true 110 5 80
Polygon -7500403 true true 105 90 120 195 90 285 105 300 135 300 150 225 165 300 195 300 210 285 180 195 195 90
Rectangle -7500403 true true 127 79 172 94
Polygon -7500403 true true 195 90 240 150 225 180 165 105
Polygon -7500403 true true 105 90 60 150 75 180 135 105

plant
false
0
Rectangle -7500403 true true 135 90 165 300
Polygon -7500403 true true 135 255 90 210 45 195 75 255 135 285
Polygon -7500403 true true 165 255 210 210 255 195 225 255 165 285
Polygon -7500403 true true 135 180 90 135 45 120 75 180 135 210
Polygon -7500403 true true 165 180 165 210 225 180 255 120 210 135
Polygon -7500403 true true 135 105 90 60 45 45 75 105 135 135
Polygon -7500403 true true 165 105 165 135 225 105 255 45 210 60
Polygon -7500403 true true 135 90 120 45 150 15 180 45 165 90

sheep
false
15
Circle -1 true true 203 65 88
Circle -1 true true 70 65 162
Circle -1 true true 150 105 120
Polygon -7500403 true false 218 120 240 165 255 165 278 120
Circle -7500403 true false 214 72 67
Rectangle -1 true true 164 223 179 298
Polygon -1 true true 45 285 30 285 30 240 15 195 45 210
Circle -1 true true 3 83 150
Rectangle -1 true true 65 221 80 296
Polygon -1 true true 195 285 210 285 210 240 240 210 195 210
Polygon -7500403 true false 276 85 285 105 302 99 294 83
Polygon -7500403 true false 219 85 210 105 193 99 201 83

square
false
0
Rectangle -7500403 true true 30 30 270 270

square 2
false
0
Rectangle -7500403 true true 30 30 270 270
Rectangle -16777216 true false 60 60 240 240

star
false
0
Polygon -7500403 true true 151 1 185 108 298 108 207 175 242 282 151 216 59 282 94 175 3 108 116 108

target
false
0
Circle -7500403 true true 0 0 300
Circle -16777216 true false 30 30 240
Circle -7500403 true true 60 60 180
Circle -16777216 true false 90 90 120
Circle -7500403 true true 120 120 60

tree
false
0
Circle -7500403 true true 118 3 94
Rectangle -6459832 true false 120 195 180 300
Circle -7500403 true true 65 21 108
Circle -7500403 true true 116 41 127
Circle -7500403 true true 45 90 120
Circle -7500403 true true 104 74 152

triangle
false
0
Polygon -7500403 true true 150 30 15 255 285 255

triangle 2
false
0
Polygon -7500403 true true 150 30 15 255 285 255
Polygon -16777216 true false 151 99 225 223 75 224

truck
false
0
Rectangle -7500403 true true 4 45 195 187
Polygon -7500403 true true 296 193 296 150 259 134 244 104 208 104 207 194
Rectangle -1 true false 195 60 195 105
Polygon -16777216 true false 238 112 252 141 219 141 218 112
Circle -16777216 true false 234 174 42
Rectangle -7500403 true true 181 185 214 194
Circle -16777216 true false 144 174 42
Circle -16777216 true false 24 174 42
Circle -7500403 false true 24 174 42
Circle -7500403 false true 144 174 42
Circle -7500403 false true 234 174 42

turtle
true
0
Polygon -10899396 true false 215 204 240 233 246 254 228 266 215 252 193 210
Polygon -10899396 true false 195 90 225 75 245 75 260 89 269 108 261 124 240 105 225 105 210 105
Polygon -10899396 true false 105 90 75 75 55 75 40 89 31 108 39 124 60 105 75 105 90 105
Polygon -10899396 true false 132 85 134 64 107 51 108 17 150 2 192 18 192 52 169 65 172 87
Polygon -10899396 true false 85 204 60 233 54 254 72 266 85 252 107 210
Polygon -7500403 true true 119 75 179 75 209 101 224 135 220 225 175 261 128 261 81 224 74 135 88 99

ufo top
false
0
Circle -1 true false 15 15 270
Circle -16777216 false false 15 15 270
Circle -7500403 true true 75 75 150
Circle -16777216 false false 75 75 150
Circle -7500403 true true 60 60 30
Circle -7500403 true true 135 30 30
Circle -7500403 true true 210 60 30
Circle -7500403 true true 240 135 30
Circle -7500403 true true 210 210 30
Circle -7500403 true true 135 240 30
Circle -7500403 true true 60 210 30
Circle -7500403 true true 30 135 30
Circle -16777216 false false 30 135 30
Circle -16777216 false false 60 210 30
Circle -16777216 false false 135 240 30
Circle -16777216 false false 210 210 30
Circle -16777216 false false 240 135 30
Circle -16777216 false false 210 60 30
Circle -16777216 false false 135 30 30
Circle -16777216 false false 60 60 30

vacuum-cleaner
true
0
Polygon -2674135 true false 75 90 105 150 165 150 135 135 105 135 90 90 75 90
Circle -2674135 true false 105 135 30
Rectangle -2674135 true false 75 105 90 120

wheel
false
0
Circle -7500403 true true 3 3 294
Circle -16777216 true false 30 30 240
Line -7500403 true 150 285 150 15
Line -7500403 true 15 150 285 150
Circle -7500403 true true 120 120 60
Line -7500403 true 216 40 79 269
Line -7500403 true 40 84 269 221
Line -7500403 true 40 216 269 79
Line -7500403 true 84 40 221 269

wolf
false
0
Polygon -16777216 true false 253 133 245 131 245 133
Polygon -7500403 true true 2 194 13 197 30 191 38 193 38 205 20 226 20 257 27 265 38 266 40 260 31 253 31 230 60 206 68 198 75 209 66 228 65 243 82 261 84 268 100 267 103 261 77 239 79 231 100 207 98 196 119 201 143 202 160 195 166 210 172 213 173 238 167 251 160 248 154 265 169 264 178 247 186 240 198 260 200 271 217 271 219 262 207 258 195 230 192 198 210 184 227 164 242 144 259 145 284 151 277 141 293 140 299 134 297 127 273 119 270 105
Polygon -7500403 true true -1 195 14 180 36 166 40 153 53 140 82 131 134 133 159 126 188 115 227 108 236 102 238 98 268 86 269 92 281 87 269 103 269 113

x
false
0
Polygon -7500403 true true 270 75 225 30 30 225 75 270
Polygon -7500403 true true 30 75 75 30 270 225 225 270

@#$#@#$#@
NetLogo 5.3
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
@#$#@#$#@
default
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0
Line -7500403 true 150 150 90 180
Line -7500403 true 150 150 210 180

shape-sensor
0.0
-0.2 0 0.0 1.0
0.0 1 1.0 0.0
0.2 0 0.0 1.0
link direction
true
0

@#$#@#$#@
0
@#$#@#$#@
