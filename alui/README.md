# alui Mudlet package

The package source is built with Muddler (link) and more information about how the build system works can be found in the project wiki (link)

# Building

You can build the package either with a globally available install of Muddler or through the docker image. The docker image is recommended.

An example build command:

```docker run --rm -v <full_path_to_PWD>:/alui -w /alui demonnic/muddler```

This will produce a `build` directory which will contain the `.mpackage` and `.xml` versions of the package