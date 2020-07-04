#!/usr/bin/env ruby

# ls libexec/vim_colorschemes.rb | entr -c ./libexec/vim_colorschemes.rb

class Colorscheme
  attr_reader :name

  def initialize(name, &config)
    @name = name
    @rules = []
    Dsl.new(self).instance_exec(&config)
  end

  def highlight(group, color, *attributes)
    @rules << Rule.new(group, Symbol === color ? Color.new(color, :none) : color, attributes)
  end

  def dump(io)
    io.puts(<<~END)
      hi clear

      if exists("syntax_on")
        syntax reset
      endif

      let colors_name = "#{@name}"

    END

    @rules.each do |rule|
      io.puts rule.format
    end
  end

  private

  class Dsl < BasicObject
    def initialize(scheme)
      @scheme = scheme
    end

    def method_missing(name, color = ::Color.new(:inherit, :inherit), *attributes)
      @scheme.highlight(name, color, *attributes)
    end
  end
end

class Color < Struct.new(:fg, :bg)
  SOLARIZED_COLORS = {
    base03: :bright_black,
    base02: :black,
    base01: :bright_green,
    base00: :bright_yellow,
    base0: :bright_blue,
    base1: :bright_cyan,
    base2: :white,
    base3: :bright_white,
    yellow: :yellow,
    orange: :bright_red,
    red: :red,
    magenta: :magenta,
    violet: :bright_magenta,
    blue: :blue,
    cyan: :cyan,
    green: :green,
  }.freeze

  ANSI_COLORS = {
    bright_black: 8,
    black: 0,
    bright_green: 10,
    bright_yellow: 11,
    bright_blue: 12,
    bright_cyan: 14,
    white: 7,
    bright_white: 15,
    yellow: 3,
    bright_red: 9,
    red: 1,
    magenta: 5,
    bright_magenta: 13,
    blue: 4,
    cyan: 6,
    green: 2,
  }.freeze

  def format
    [
      format_ansi_color(:fg),
      format_ansi_color(:bg),
    ].compact.join(" ")
  end

  def format_ansi_color(field)
    name = send(field)
    return if name == :inherit
    color = name == :none ? "NONE" : ANSI_COLORS.fetch(SOLARIZED_COLORS.fetch(name))
    "cterm#{field}=#{color}"
  end
end

class Rule < Struct.new(:group, :color, :attributes)
  def format
    "highlight! #{group} #{color.format} #{format_attributes}"
  end

  def format_attributes
    if attributes.empty?
      "cterm=NONE"
    else
      "cterm=#{attributes.join(",")}"
    end
  end
end

module Refinements
  refine Symbol do
    def /(other)
      Color.new(self, other)
    end
  end
end

using Refinements

scheme = Colorscheme.new("solarized_16") {
  SpecialKey :base0 / :base2, :bold
  NonText :base0, :bold
  Directory :blue
  ErrorMsg :red, :reverse
  IncSearch :orange, :standout
  Search :yellow, :reverse
  MoreMsg :blue
  ModeMsg :blue
  LineNr :base1 / :base2
  # CursorLineNr
  Question :cyan, :bold
  StatusLine :base01 / :base2, :reverse
  StatusLineNC :base0 / :base2, :reverse
  VertSplit :base0 / :base0
  Title :orange, :bold
  Visual :base1 / :base3, :reverse
  VisualNOS :none / :base2, :reverse
  WarningMsg :red, :bold
  WildMenu :base02 / :base2, :reverse
  Folded :base00 / :base2, :bold, :underline
  FoldColumn :base00 / :base2
  DiffAdd :green / :base2
  DiffChange :yellow / :base2
  DiffDelete :red / :base2
  DiffText :blue / :base2
  SignColumn :base00 / :inherit
  Conceal :blue
  SpellBad :none, :undercurl
  SpellCap :none, :undercurl
  SpellRare :none, :undercurl
  SpellLocal :none, :undercurl
  Pmenu :base00 / :base2, :reverse
  PmenuSel :base1 / :base02, :reverse
  PmenuSbar :base02 / :base00, :reverse
  PmenuThumb :base00 / :base3, :reverse
  TabLine :base00 / :base2, :underline
  TablineSel :base1 / :base02, :reverse, :underline
  TabLineFill :base00 / :base2, :underline
  CursorColumn :none / :base2
  CursorLine :none / :base2
  ColorColumn :none / :base2
  # StatusLineTerm
  # StatusLineTermNC
  Normal :base00 / :base3 # TODO can we remove the background?

  MatchParen :red / :base1, :bold
  # ToolbarLine
  # ToolbarButton
  Comment :base1
  Constant :cyan
  Special :red
  Identifier :blue
  Statement :green
  PreProc :orange
  Type :yellow
  Underlined :violet
  Ignore :none
  Error :red, :bold
  Todo :magenta, :bold

  diffAdded :green # TODO link to Statement

  gitcommitComment :base1
  gitcommitUntracked :base1 # TODO link to gitcommitComment
  gitcommitDiscarded :base1 # TODO link to gitcommitComment
  gitcommitSelected :base1 # TODO link to gitcommitComment
  gitcommitUnmerged :green, :bold
  gitcommitOnBranch :base1, :bold
  gitcommitBranch :magenta, :bold
  gitcommitNoBranch :magenta, :bold # TODO link to gitcommitBranch
  gitcommitDiscardedType :red
  gitcommitSelectedType :green
  gitcommitHeader :base1
  gitcommitUntrackedFile :cyan, :bold
  gitcommitDiscardedFile :red, :bold
  gitcommitSelectedFile :green, :bold
  gitcommitUnmergedFile :yellow, :bold
  gitcommitFile :base00, :bold

  rubyDefine :base01 / :base3, :bold
}

scheme.dump(STDOUT)

File.open("etc/vim/colors/#{scheme.name}.vim", "w") do |io|
  scheme.dump(io)
end
