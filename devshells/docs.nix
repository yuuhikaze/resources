{ pkgs, tern-core, resources-root }:

pkgs.mkShell {
  name = "tern+pandoc_resources-shell";

  buildInputs = [ pkgs.pandoc tern-core ];

  shellHook = ''
    # Set up Tern converter
    mkdir -p ~/.local/share/tern/converters
    ln -sf ${resources-root}/tern-converters/pandoc.lua ~/.local/share/tern/converters/pandoc.lua

    # Locate docs dir (build)
    DOCS_DIR=$(dirname "$(readlink -f "$0")")
    DOCS_DIR="''${DOCS_DIR%/docs*}/docs"
    echo $DOCS_DIR

    # Symlink pandoc-templates into docs dir
    mkdir "$DOCS_DIR/pandoc-templates"
    ln -sf ${resources-root}/pandoc-templates/docs.html "$DOCS_DIR/pandoc-templates"
    ln -sf ${resources-root}/pandoc-templates/docs.css "$DOCS_DIR/pandoc-templates"

    # Export convenience environment variables
    export PANDOC_DOCS_HTML="$DOCS_DIR/pandoc-templates/docs.html"
    export PANDOC_DOCS_CSS="$DOCS_DIR/pandoc-templates/docs.css"

    # Print information
    echo "====== Documentation Environment ======"
    echo "Tern:   $(tern-core --version)"
    echo "Pandoc: $(pandoc --version | head -n 1)"
    echo "Resources synced ✓"
    echo "======================================="
  '';
}
