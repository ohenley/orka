[![License](https://img.shields.io/:license-Apache_License_2.0-blue.svg)](https://github.com/onox/orka/blob/master/LICENSE.md)

Orka
====

Orka is the OpenGL Rendering Kernel in Ada. It is written in Ada 2012
and provides an object-oriented API for modern OpenGL. Orka makes it easy
to construct OpenGL programs and meshes and to use them in a scene tree.
Orka and the OpenGL bindings require and use OpenGL 4.5's Direct State
Access (DSA) extension.

Orka builds upon and provides thick bindings for OpenGL 4.5. These bindings
are based on the original [OpenGLAda][url-openglada] bindings. Bindings for
the fixed function functionality have been removed and bindings for various
extensions of OpenGL 4.x have been added.

Additionally, it provides bindings for [GLFW 3.x][url-glfw]. This is a library
for creating windows with an OpenGL context on them. It also provides
functionality for capturing user input on keyboard, mouse and joystick.
Having a window with an OpenGL context is the prerequisite for using any
OpenGL functionality.

Orka is supported on Linux and Windows. Support for OS X has been removed
due to its very outdated OpenGL drivers (most of the required OpenGL 4.x
extensions have not been implemented in their drivers).

Features
--------

 * Thick OpenGL 4.5 bindings
 * Thick GLFW 3 bindings
 * Various x86 SIMD extensions like SSE, SSE2, SSE3, SSE4.1, AVX, and F16C
 * Easy construction of shader programs and meshes
 * Transforms and scene tree (makes use of the x86 SIMD extensions)
 * Game loop
 * Camera's
 * [glTF 2.0][url-gltf] loader (uses MDI)
 * [KTX][url-ktx] loader

Build status
------------

|                    | Linux   | Windows     |
|--------------------|---------|-------------|
| **GNAT GPL 2015**  | passing | unknown     |
| **GNAT GPL 2016**  | link failure | unknown     |
| **GNAT GPL 2017**  | unknown | unknown     |
| **GNAT FSF 6.3**   | unknown | unknown     |

Dependencies
------------

In order to build Orka you need to have:

 * A GNAT compiler that supports Ada 2012 (Either GNAT GPL from [AdaCore's Libre Site][url-adacore],
   or the GNAT [version provided by the FSF with GCC][url-fsf])

 * [GPRBuild][url-gprbuild] (Is bundled with AdaCore's GNAT distribution)

 * OpenGL 3.2 core profile and the following extensions:

    | Extension                          | OpenGL | Reason      |
    |------------------------------------|--------|-------------|
    | ARB\_direct\_state\_access         | 4.5    |             |
    | ARB\_buffer\_storage               | 4.4    |             |
    | KHR\_debug                         | 4.3    | Debugging   |
    | ARB\_multi\_draw\_indirect         | 4.3    | .gltf       |
    | ARB\_program\_interface\_query     | 4.3    | Subroutines |
    | ARB\_vertex\_attrib\_binding       | 4.3    |             |
    | ARB\_texture\_storage\_multisample | 4.3    | Textures    |
    | ARB\_texture\_storage              | 4.2    | Textures    |
    | ARB\_separate\_shader\_objects     | 4.1    |             |

 * An x86-64 CPU with the AVX and F16C extensions

Optional dependencies:

 * [Ahven 2][url-ahven] if you want to build and run the unit tests

 * [GLFW 3][url-glfw] for the GLFW bindings

Compilation
-----------

A Makefile is provided to build the source code and examples. Use `make` to build
the source code:

```sh
$ MODE=release make
```

If you want to check after each call to OpenGL whether an error flag was set
and raise a corresponding exception, then use the `development` mode:

```sh
$ MODE=development make
```

The default mode is `development`. Both `release` and `development` enable general
optimizations. To enable OpenGL exceptions, disable optimizations, and include
debugging symbols, use the `debug` mode. See the following table:

|                   | Release | Development | Debug |
|-------------------|---------|-------------|-------|
| Optimizations     | Yes     | Yes         | No    |
| Assertions        | No      | Yes         | Yes   |
| OpenGL exceptions | No      | Yes         | Yes   |
| Debugging symbols | No      | No          | Yes   |

Examples
--------

The project contains some examples that demonstrate the basic usage of
the library. Build the example programs as follows:

```sh
$ make examples
```

You can execute them in the `bin` directory. Some examples load shader
files from the source directory by using relative paths, so they only work
with `bin` as the current directory.

Tests
-----

The project contains a set of unit tests. Use `make test` to build the unit tests:

```sh
$ make test
```

After having build the tests, run the unit tests:

```sh
$ make run_unit_tests
```

Installation
------------

After having compiled the source code, the library can be installed by executing:

```sh
$ make PREFIX=/usr install
```

Change `PREFIX` to the preferred destination folder.

Using Orka in your project
--------------------------

Specify the dependency in your \*.gpr project file:

```ada
with "orka";
```

If you want to use GLFW, refer to `orka-glfw` instead. The project files
`orka.gpr` and `orka-glfw.gpr` take the following scenario parameters:

 * `Windowing_System`: Sets the backend windowing system. Used for GLFW and also
                       for system-dependent parts of the API (GLX, WGL):

    - `x11`: X Windowing System (Linux, BSD, etc)
    - `windows`: Microsoft Windows

 * `Mode`: May take one of the following values: `debug`, `development`, or `release`.

 * `GLFW_Lib`: Linker flags for GLFW. The default is `-lglfw`.

License
-------

The OpenGL and GLFW bindings and Orka are distributed under the terms
of the [Apache License 2.0][url-apache].

  [url-openglada]: https://github.com/flyx/OpenGLAda
  [url-glfw]: http://www.glfw.org/
  [url-adacore]: http://libre.adacore.com/
  [url-fsf]: https://gcc.gnu.org/wiki/GNAT
  [url-gprbuild]: http://www.adacore.com/gnatpro/toolsuite/gprbuild/
  [url-ahven]: http://ahven.stronglytyped.org
  [url-apache]: https://opensource.org/licenses/Apache-2.0
  [url-gltf]: https://github.com/KhronosGroup/glTF/blob/master/specification/2.0/README.md
  [url-ktx]: https://www.khronos.org/opengles/sdk/tools/KTX/file_format_spec/

