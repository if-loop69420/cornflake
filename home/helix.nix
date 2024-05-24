pkgs:
{
  enable = true;
  settings = {
  theme = "catppuccin_mocha";
  editor = {
      true-color = true;
      color-modes = true;
      cursorline = true;
      cursor-shape = {
        insert = "bar";
        normal = "block";
        select = "underline";
      };
      indent-guides = {
        render = true;
        rainbow = "dim";
      
 languages = [
    {
      name = "nix";
      auto-format = true;
    }
    {
      name = "rust";
      auto-format = true;
    }
    {
      name = "go";
    }
    {
      name = "lua";
    }
    {
      name = "python";
    }
    {
      name = "markdown";
    }
    {
      name = "html";
      injection-regex = "html";
      file-types = ["svelte" "html"];
      language-server = { command="html-languageserver";};
    }
    {
      name = "css";
    }
    {
      name = "yaml";
    }
    {
      name = "meson";
      auto-format = true;
    }
    {
      name = "cpp";
      auto-format = true;
    }
   ];
  };
 };
};
}
