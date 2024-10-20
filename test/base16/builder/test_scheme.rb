# frozen_string_literal: true

require "test_helper"

module Base16
  module Builder
    class TestScheme < Minitest::Test
      def test_to_context
        materia_yaml = {
          "scheme" => +"Materia",
          "author" => +"Defman21",
          "base00" => +"263238",
          "base01" => +"2C393F",
          "base02" => +"37474F",
          "base03" => +"707880",
          "base04" => +"C9CCD3",
          "base05" => +"CDD3DE",
          "base06" => +"D5DBE5",
          "base07" => +"FFFFFF",
          "base08" => +"EC5F67",
          "base09" => +"EA9560",
          "base0A" => +"FFCC00",
          "base0B" => +"8BD649",
          "base0C" => +"80CBC4",
          "base0D" => +"89DDFF",
          "base0E" => +"82AAFF",
          "base0F" => +"EC5F67"
        }

        scheme = Scheme.new("materia", materia_yaml)

        actual_context = scheme.to_context

        assert_equal({"scheme-name" => "Materia", "scheme-author" => "Defman21", "scheme-slug" => "materia", "base00-hex" => "263238", "base00-hex-r" => "26", "base00-hex-g" => "32", "base00-hex-b" => "38", "base00-rgb-r" => "38", "base00-rgb-g" => "50", "base00-rgb-b" => "56", "base00-dec-r" => 0.14901960784313725, "base00-dec-g" => 0.19607843137254902, "base00-dec-b" => 0.2196078431372549, "base01-hex" => "2C393F", "base01-hex-r" => "2C", "base01-hex-g" => "39", "base01-hex-b" => "3F", "base01-rgb-r" => "44", "base01-rgb-g" => "57", "base01-rgb-b" => "63", "base01-dec-r" => 0.17254901960784313, "base01-dec-g" => 0.2235294117647059, "base01-dec-b" => 0.24705882352941178, "base02-hex" => "37474F", "base02-hex-r" => "37", "base02-hex-g" => "47", "base02-hex-b" => "4F", "base02-rgb-r" => "55", "base02-rgb-g" => "71", "base02-rgb-b" => "79", "base02-dec-r" => 0.21568627450980393, "base02-dec-g" => 0.2784313725490196, "base02-dec-b" => 0.30980392156862746, "base03-hex" => "707880", "base03-hex-r" => "70", "base03-hex-g" => "78", "base03-hex-b" => "80", "base03-rgb-r" => "112", "base03-rgb-g" => "120", "base03-rgb-b" => "128", "base03-dec-r" => 0.4392156862745098, "base03-dec-g" => 0.47058823529411764, "base03-dec-b" => 0.5019607843137255, "base04-hex" => "C9CCD3", "base04-hex-r" => "C9", "base04-hex-g" => "CC", "base04-hex-b" => "D3", "base04-rgb-r" => "201", "base04-rgb-g" => "204", "base04-rgb-b" => "211", "base04-dec-r" => 0.788235294117647, "base04-dec-g" => 0.8, "base04-dec-b" => 0.8274509803921568, "base05-hex" => "CDD3DE", "base05-hex-r" => "CD", "base05-hex-g" => "D3", "base05-hex-b" => "DE", "base05-rgb-r" => "205", "base05-rgb-g" => "211", "base05-rgb-b" => "222", "base05-dec-r" => 0.803921568627451, "base05-dec-g" => 0.8274509803921568, "base05-dec-b" => 0.8705882352941177, "base06-hex" => "D5DBE5", "base06-hex-r" => "D5", "base06-hex-g" => "DB", "base06-hex-b" => "E5", "base06-rgb-r" => "213", "base06-rgb-g" => "219", "base06-rgb-b" => "229", "base06-dec-r" => 0.8352941176470589, "base06-dec-g" => 0.8588235294117647, "base06-dec-b" => 0.8980392156862745, "base07-hex" => "FFFFFF", "base07-hex-r" => "FF", "base07-hex-g" => "FF", "base07-hex-b" => "FF", "base07-rgb-r" => "255", "base07-rgb-g" => "255", "base07-rgb-b" => "255", "base07-dec-r" => 1.0, "base07-dec-g" => 1.0, "base07-dec-b" => 1.0, "base08-hex" => "EC5F67", "base08-hex-r" => "EC", "base08-hex-g" => "5F", "base08-hex-b" => "67", "base08-rgb-r" => "236", "base08-rgb-g" => "95", "base08-rgb-b" => "103", "base08-dec-r" => 0.9254901960784314, "base08-dec-g" => 0.37254901960784315, "base08-dec-b" => 0.403921568627451, "base09-hex" => "EA9560", "base09-hex-r" => "EA", "base09-hex-g" => "95", "base09-hex-b" => "60", "base09-rgb-r" => "234", "base09-rgb-g" => "149", "base09-rgb-b" => "96", "base09-dec-r" => 0.9176470588235294, "base09-dec-g" => 0.5843137254901961, "base09-dec-b" => 0.3764705882352941, "base0A-hex" => "FFCC00", "base0A-hex-r" => "FF", "base0A-hex-g" => "CC", "base0A-hex-b" => "00", "base0A-rgb-r" => "255", "base0A-rgb-g" => "204", "base0A-rgb-b" => "0", "base0A-dec-r" => 1.0, "base0A-dec-g" => 0.8, "base0A-dec-b" => 0.0, "base0B-hex" => "8BD649", "base0B-hex-r" => "8B", "base0B-hex-g" => "D6", "base0B-hex-b" => "49", "base0B-rgb-r" => "139", "base0B-rgb-g" => "214", "base0B-rgb-b" => "73", "base0B-dec-r" => 0.5450980392156862, "base0B-dec-g" => 0.8392156862745098, "base0B-dec-b" => 0.28627450980392155, "base0C-hex" => "80CBC4", "base0C-hex-r" => "80", "base0C-hex-g" => "CB", "base0C-hex-b" => "C4", "base0C-rgb-r" => "128", "base0C-rgb-g" => "203", "base0C-rgb-b" => "196", "base0C-dec-r" => 0.5019607843137255, "base0C-dec-g" => 0.796078431372549, "base0C-dec-b" => 0.7686274509803922, "base0D-hex" => "89DDFF", "base0D-hex-r" => "89", "base0D-hex-g" => "DD", "base0D-hex-b" => "FF", "base0D-rgb-r" => "137", "base0D-rgb-g" => "221", "base0D-rgb-b" => "255", "base0D-dec-r" => 0.5372549019607843, "base0D-dec-g" => 0.8666666666666667, "base0D-dec-b" => 1.0, "base0E-hex" => "82AAFF", "base0E-hex-r" => "82", "base0E-hex-g" => "AA", "base0E-hex-b" => "FF", "base0E-rgb-r" => "130", "base0E-rgb-g" => "170", "base0E-rgb-b" => "255", "base0E-dec-r" => 0.5098039215686274, "base0E-dec-g" => 0.6666666666666666, "base0E-dec-b" => 1.0, "base0F-hex" => "EC5F67", "base0F-hex-r" => "EC", "base0F-hex-g" => "5F", "base0F-hex-b" => "67", "base0F-rgb-r" => "236", "base0F-rgb-g" => "95", "base0F-rgb-b" => "103", "base0F-dec-r" => 0.9254901960784314, "base0F-dec-g" => 0.37254901960784315, "base0F-dec-b" => 0.403921568627451}, actual_context)
      end
    end
  end
end
