# Path\_Solver

## Description

This project is a visualization of
[dijkstra's algorithm](https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm)
with an ada implementation, [gtkada](https://github.com/AdaCore/gtkada) for the GUI; and using a procedural world generation for the map.

As it is my first time using gtkAda, I extensively relied on
[the examples](https://github.com/AdaCore/gtkada/tree/master/testgtk) provided.

### World Generation

 ![The world](./doc/Layer_6_160.png) ![The world](./doc/Layer_6_160_2.png)  \
 ![The world](./doc/Layer_6_160_3.png) ![The world](./doc/Layer_6_160_4.png) \
*160x160 worlds generated with a minecraft-like algorithm*

#### Introduction

The first part of the project is to generate a map on which the algorithm will be able to evolve later on.
For this, I relied on the pre-existing minecraft algorithm described in [this article](https://www.alanzucconi.com/2022/06/05/minecraft-world-generation/). As such, the terminology and the description pictures' will be similar.

To generate our map, I use what I came to call the " Zooming principle ". I start with a view of the world as far aways as possible (maximum zoomed out) and progressively zoom in has I add more features. This technic is useful because it allows for a progressive creation of many details as each new map has double the number of pixels as the last.

#### Stack

The processus - the stack - is so named as it is a composition of many layers, each one having a specific instruction :

- Island : the first layer in the stack : it creates a basic map with only land and ocean in a 3 to 10 ratio.

- Zoom : Create a new map double the size from the last.

- Add_Islands : Add/Erode land to the current map with the help a horizontal and a vertical image gradient.

- Init_Temperature_Z5 : Initialize a temperature map where each point has a value from 1 to 5 which represent the zone general biome. The map is generated using [perlin noise](https://en.wikipedia.org/wiki/Perlin_noise).

- Smooth_Temperature : Smooth the temperature map for less abrupt variations using kernel image gradients. Indeed, because of perlin noise's caracteristic
at grid point, there is a null gradient resulting in a singularity, which feels off when plotted at the biome layer.

- Remove_Too_Much : This is a [dilation / erosion operator](https://en.wikipedia.org/wiki/Mathematical_morphology#Basic_operators) (depending on what you choose to erode) that I initialy created to remove small patch of ocean (think of a 1x1 ocean in land).

- Place_Biome : Use the temperature map from earlier [1] to decide what color will the rocks take. Because of the [number of subBiomes](./src/constants.ads (L.43 and following)), a random one-to-one surjection between biome and temperature number is impossible. As such, each subbiome has a probability of being choosen and is then placed into the zone by a [diffusion process (L.467 and following (sub-functions above))](./src/model/generation/generation.adb).

- Place_Topography : Using the same general algorithm as the [Generate_Baseline function(L.462)](./src/model/generation/generation.adb), it creates a general map
for the ocean and the hills that are then placed on top of the previous layer.

The current stack I'm using can be seen below :

| ![The stack](./doc/stack.jpg) |
|:--:|
| *The current stack* |

[1] Some details where omitted. In reality, the temperature map pass by a Scale_Map function to make the futur biomes bigger.

## Configuration

### Introduction

The project use Alire as its main compiling tool.

To install Alire, please download the [binary file](https://alire.ada.dev/) and unpack it somewhere. Then, add Alire to the path with
```export PATH="<PATH_TO_EXTRACTED>/bin/:$PATH"``` (you can make it permanent by placing this in the .profile).

### Dependency

To run, the project must use some dependencies. Apart from those below - and which can be installed in the project's folder using ```alr with <Dependency>``` - the project also use a python script. Thus, one must have python3 installed on their computer for it to properly run.

| ![dependency_graph](./doc/dependency_graph.jpg) |
|:--:|
| *The project's dependency graph* |

### Build

To build the project, run ```alr build``` in the project folder, or
alternatively ```alr run``` to build and execute. The generated binary file is located in ./bin and must be executed here.

There is currently to binaries associated with the project :
- path_solver : the main program visualizing Dijkstra's algorithm
- generation_main : the program that creates the procedural map. It is a test file for developpement purposes. Its result can be seen on the last layer in [layer/templates](./layer_templates/).




