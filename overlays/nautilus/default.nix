self: super: {
  gnome = super.gnome.overrideScope (gself: gsuper: {
    nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
      buildInputs = nsuper.buildInputs ++ [
        gsuper.gst_all_1.gst-plugins-good
        gsuper.gst_all_1.gst-plugins-bad
      ];
    });
  });
}