{ pkgs, tern-core, resources-root }:

pkgs.mkShell {
  name = "tern+pandoc_resources-shell";

  buildInputs = [ pkgs.pandoc pkgs.structurizr-cli pkgs.plantuml tern-core ];

  shellHook = ''
    # Set up Tern converter
    mkdir -p ~/.local/share/tern/converters
    ln -sf ${resources-root}/tern-converters/pandoc.lua ~/.local/share/tern/converters/pandoc.lua
    ln -sf ${resources-root}/tern-converters/structurizr.lua ~/.local/share/tern/converters/structurizr.lua
    ln -sf ${resources-root}/tern-converters/plantuml.lua ~/.local/share/tern/converters/plantuml.lua

    # Locate docs dir (build)
    ROOT_DIR=$(dirname "$(readlink -f "$0")")
    DOCS_DIR="''${ROOT_DIR%/docs*}/docs"

    # Symlink pandoc-templates into docs dir
    mkdir -p "$DOCS_DIR/pandoc-templates"
    ln -sf ${resources-root}/pandoc-templates/docs.html "$DOCS_DIR/pandoc-templates"
    ln -sf ${resources-root}/pandoc-templates/docs.css "$DOCS_DIR/pandoc-templates"

    # Symlink resources dir into docs dir, e.g resources/images, resources/audio
    mkdir -p "$ROOT_DIR/docs-src/resources"
    ln -sf "$ROOT_DIR/docs-src/resources" "$ROOT_DIR/docs"

    # Export convenience environment variables
    export PANDOC_DOCS_HTML="$DOCS_DIR/pandoc-templates/docs.html"
    export PANDOC_DOCS_CSS="/pandoc-templates/docs.css"

    # Print information
    echo "====== Documentation Environment ======"
    echo "Tern:   $(tern-core --version)"
    echo "Pandoc: $(pandoc --version | head -n 1)"
    echo "Resources synced ✓"
    echo "======================================="
  '';
}
