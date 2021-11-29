[![Build status](https://github.com/onox/orka/actions/workflows/build.yaml/badge.svg)](https://github.com/onox/orka/actions/workflows/build.yaml)
[![Test status](https://github.com/onox/orka/actions/workflows/test.yml/badge.svg)](https://github.com/onox/orka/actions/workflows/test.yml)
[![Docs status](https://img.shields.io/netlify/4fa61148-e68f-41e6-b7fa-1785eaf4bcb5?label=docs)](https://app.netlify.com/sites/orka-engine/deploys)
[![License](https://img.shields.io/github/license/onox/orka.svg?color=blue)](https://github.com/onox/orka/blob/master/LICENSE)
[![GitHub release](https://img.shields.io/github/release/onox/orka.svg)](https://github.com/onox/orka/releases/latest)
[![IRC](https://img.shields.io/badge/IRC-%23ada%20on%20libera.chat-orange.svg)](https://libera.chat)
[![Gitter chat](https://badges.gitter.im/gitterHQ/gitter.svg)](https://gitter.im/ada-lang/Lobby)

# Orka

Orka is an OpenGL 4.6 rendering kernel written in Ada 2012. It provides
the building blocks to easily render 3D graphics or do general-purpose
computing on the GPU, and to use input devices like gamepads.

- **Object-oriented rendering API**. Renderer objects like shader programs,
framebuffers, buffers, and textures can be used via an
object-oriented API. Objects are automatically created and destroyed by using
controlled types. Various [AZDO][url-azdo] techniques can be used to allow
multithreaded buffer updates and batched draw calls for high performance rendering.

- **Debug rendering and logging**. Various packages exist that can be used
to draw bounding boxes, coordinate axes, lines, and spheres for debugging.
Messages from the rendering API or other parts of your application can be
logged to the terminal or files.

- **Algorithms and effects**. Compute the prefix sum or Fast Fourier Transform
using compute shaders, or apply a blurring effect to a texture.

- **Atmosphere and terrain**. Render a realistic atmosphere or adaptive
tessellated terrain.

- **Joysticks and gamepads**. Manage joysticks and gamepads.
Analog axes can be filtered with a low-pass filter, dead zones
can be removed, and axes and triggers can be inverted or normalized.
It is possible to detect chords (groups of buttons), button sequences,
and rapid button tapping.

- **Job graph processing system**. A job graph processing system provides
flexible multitasking by allowing work to be split into multiple small jobs
which are then processed by any available task from a task pool. Jobs can be
processed in parallel as well as sequentially.

- **Asynchronous resource loading**. Load resources like [KTX][url-ktx] textures
and [glTF][url-gltf] models asynchronously using the job graph
processing system. Resources can be loaded from directories and archive files.

- **Transforms**. Apply common transformations to vectors, quaternions, and
matrices using x86 SIMD instructions.

- **Numerics**. Perform element-wise operations, reductions
using arbitrary expressions, or matrix operations on tensors using SIMD
instructions. Generate tensors with statistical distributions or use
Runge-Kutta 4th order numerical integrators.

Additionally, Orka provides several bindings:

- **x86 SIMD extensions**
Bindings for various x86 SIMD extensions, including SSE, SSE2, SSE3, SSSE3,
SSE4.1, AVX, AVX2, FMA, and F16C, and an implementation of the
[xoshiro128++][url-xoshiro] pseudo-random number generator using SSE2 or
AVX2 intrinsics.

- **OpenGL 4.6**. Thick bindings are provided for the modern parts
of OpenGL 4.6. There are no bindings for fixed function functionality
that is deprecated or functions that have been superseded by newer extensions.

- **EGL**. Thick bindings for EGL are provided to create a surfaceless
context for rendering without the presence of a windowing system.

## Ada Window Toolkit

[AWT][url-awt] is used to create windows that can display 3D graphics with
an OpenGL context and to manage input devices like the pointer, keyboard, and
gamepads. It has a similar purpose as GLFW and SDL. Alternatively, a library like
[SDL][url-sdl] can be used instead to create windows and process input.

Currently there is only a Wayland backend for Linux. Hopefully in the future a
backend for Windows will be added.

AWT also supports gamepads:

- **Mappings**. Use mappings from the [SDL gamecontroller database][url-sdl-gamecontroller-db].

- **Events**. Listen for (dis)connection events.

- **Force-feedback**. Play and cancel rumble and periodic force-feedback effects.

- **Motion sensor**. Get the linear acceleration and angular velocity using the motion
  sensor of a gamepad.

- **Battery**. Retrieve the capacity and charging state of the battery of a gamepad.

- **LED**. Get and set the color of the LED of a gamepad.

## Documentation

The documentation can be viewed [on the website][url-docs].

## Learning Ada

Ada is an imperative and object-oriented programming language focused
on correctness, readability, and good [software engineering practices][url-swe-practices]
for large scale systems and safety-critical and embedded real-time systems.

It has a very strong static type system where you can create your own
types that reflect the problem domain, with optional low-level control
of your data. Packages provide modularity and information hiding. High-level
concurrency primitives like protected objects allow safe communication
between tasks and design-by-contract is supported through type invariants,
predicates, and pre- and postconditions.

If you would like to learn Ada, then here are a few resources to get started:

- [Introduction to Ada][url-learn-act] (An interactive tutorial in your browser)

- [Ada Programming on Wikibooks][url-wikibooks]

- [(Online) books on Awesome Ada][url-awesome]

## Contributing

If you would like to fix a bug, add a feature, improve the documentation or
have suggestions or advice about the architecture, APIs, or performance,
then do not hesitate to open a new [issue][url-issue].

Make sure you have read the [contributing guidelines][url-contributing]
before opening an issue or pull request.

## License

Most Orka crates are distributed under the terms of the [Apache License 2.0][url-apache]
except for a few separate Alire crates:

- Crate [orka_plugin_atmosphere][url-crate-atmosphere] is licensed under
the [Apache License 2.0][url-apache] AND [BSD 3-Clause license][url-bsd-3].

- Crate [orka_plugin_terrain][url-crate-terrain] is licensed under
the [Apache License 2.0][url-apache] AND [MIT license][url-mit].

  [url-apache]: https://opensource.org/licenses/Apache-2.0
  [url-awt]: https://github.com/onox/orka/tree/master/awt
  [url-bsd-3]: https://opensource.org/licenses/BSD-3-Clause
  [url-crate-atmosphere]: https://github.com/onox/orka/tree/master/orka_plugin_atmosphere
  [url-crate-terrain]: https://github.com/onox/orka/tree/master/orka_plugin_terrain
  [url-mit]: https://opensource.org/licenses/MIT
  [url-awesome]: https://github.com/ohenley/awesome-ada#online-books
  [url-azdo]: https://www.khronos.org/assets/uploads/developers/library/2014-gdc/Khronos-OpenGL-Efficiency-GDC-Mar14.pdf
  [url-contributing]: /CONTRIBUTING.md
  [url-docs]: https://orka-engine.netlify.com/
  [url-gltf]: https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md
  [url-issue]: https://github.com/onox/orka/issues
  [url-ktx]: https://www.khronos.org/opengles/sdk/tools/KTX/file_format_spec/
  [url-learn-act]: https://learn.adacore.com/courses/intro-to-ada/index.html
  [url-sdl]: https://github.com/lucretia/sdlada
  [url-sdl-gamecontroller-db]: https://github.com/gabomdq/SDL_GameControllerDB
  [url-swe-practices]: https://en.wikibooks.org/wiki/Ada_Programming#Programming_in_the_large
  [url-wikibooks]: https://en.wikibooks.org/wiki/Ada_Programming
  [url-xoshiro]: https://prng.di.unimi.it/
