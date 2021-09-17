blender-custom
==============

Scripts to create a customized portable linux-x64 build of Blender with patches applied.


TL;DR Where Can I Download It?
------------------------------

We'll keep this post updated as we generate new builds with the latest download links: [DOWNLOAD: Blender 2.93 LTS with Outline Patch for Linux](https://yerface.live/2021/09/17/outline-node-blender-build.html)


Rationale
---------

As you know, around here we _love_ cartoon-style animation mixed with video. Aesthetically, think _[Who Framed Roger Rabbit](https://en.wikipedia.org/wiki/Who_Framed_Roger_Rabbit)_ and you'll know what we mean.

To accomplish this, we often mix photorealistic (PBR) and cartoon (NPR) rendering styles in the same Blender scene and render that scene with Blender's _Cycles_ rendering engine.

Recently we've adopted [Miguel Pozo's](https://twitter.com/pragma37) incredible Blender Outline Material Node to power our toon style. You can read more about it here:

  - [Material Node Documentation](https://blender-outline-node-docs.netlify.app/)
  - [Material Node Patch D7270](https://developer.blender.org/D7270) and related discussion at developer.blender.org.
  - [Patched Windows Build](https://pragma37.gumroad.com/l/blender-outline-node) on Gumroad provided by Miguel himself.


Unfortunately, because Blender does not provide any way to extend Cycles at runtime without sacrificing GPU acceleration, the Blender source code must be patched before being compiled. (OSL script nodes do not count here because they are incompatible with GPU acceleration.)

So until Blender officially supports the Outline Material Node (or a suitable replacement) we are providing patched builds of Blender 2.93 LTS for Linux x86_64 to compliment Miguel's own Windows builds!


Please Help
-----------

Would you like to help? Please [join the discussion](https://developer.blender.org/D7270) on developer.blender.org and let the Blender developers know that you need the Outline Material Node to be officially supported in Blender!


Who Are We?
-----------

We are Markley Bros. Entertainment. Please see [MBE.tv](https://mbe.tv/) and [YerFace!](https://yerface.live/) for more information about us and our interest in Blender.

