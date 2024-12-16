\NeedsTeXFormat{LaTeX2e}
\RequirePackage{expl3}
\ProvidesExplClass{textbook}
  {2024-07-19}{1.0.0}{TextBook Template for Middle School}
\RequirePackage { xtemplate, l3keys2e}
% -----------------------------------------------------------------------------
% LaTeX3 版本检查
% -----------------------------------------------------------------------------
\clist_map_inline:nn { xtemplate, l3keys2e }
  {
    \@ifpackagelater {#1} { 2020/07/17 }
      { } { \msg_error:nnn { textbook } { l3-too-old } {#1} }
  }
\msg_new:nnn { textbook } { l3-too-old }
  {
    Package~ "#1"~ is~ too~ old. \\\\
    Please~ update~ an~ up-to-date~ version~ of~ the~ bundles \\
    "l3kernel"~ and~ "l3packages"~ using~ your~ TeX~ package \\
    manager~ or~ from~ CTAN.
  }
% -----------------------------------------------------------------------------
% 系统检查
% -----------------------------------------------------------------------------
\sys_if_engine_xetex:F
  {
    \msg_fatal:nnx { textbook } { unsupported-engine } { \c_sys_engine_str }
  }
\msg_new:nnn { textbook } { unsupported-engine }
  {
    The~ textbook~ class~ requires~ XeTeX~ only. \\\\
    "#1"~ is~ not~ supported~ at~ present.~ You~ must~ change \\
    your~ typesetting~ engine~ to~ "xelatex".
  }
% -----------------------------------------------------------------------------
% 模式改变
% -----------------------------------------------------------------------------
\cs_generate_variant:Nn \file_input:n { x }
% -----------------------------------------------------------------------------
% 变量声明
% -----------------------------------------------------------------------------
\bool_new:N      \g__txbk_twoside_bool
\bool_set_true:N \g__txbk_twoside_bool
\clist_new:N     \g__txbk_to_ctexbook_clist
\int_new:N       \g__txbk_color_theme_series_int
\tl_new:N        \g__txbk_color_theme_series_tl
\tl_new:N        \g__txbk_release_date_tl
\tl_new:N        \g__txbk_print_date_tl
\tl_new:N        \g__txbk_book_title_pdf_zh_tl
\bool_new:N      \g__txbk_emph_bold_bool
% -----------------------------------------------------------------------------
% 常量设定
% -----------------------------------------------------------------------------
\tl_const:Nn \c__txbk_fwid_full_stop_tl { ^^^^ff0e }
% -----------------------------------------------------------------------------
% 选项设定
% -----------------------------------------------------------------------------
\keys_define:nn { txbk / option }
  {
    oneside .value_forbidden:n = true,
    twoside .value_forbidden:n = true,
    oneside .code:n =
      {
        \clist_gput_right:Nn \g__txbk_to_ctexbook_clist { oneside }
        \bool_set_false:N    \g__txbk_twoside_bool
      },
    twoside .code:n =
      {
        \clist_gput_right:Nn \g__txbk_to_ctexbook_clist { twoside }
        \bool_set_true:N     \g__txbk_twoside_bool
      },
    colortheme   .choice:, 
    colortheme   .value_required:n = true, 
    colortheme   .choices:nn  = 
      { red, brown, yellow, olive, green, teal, cyan, azure, blue, violet, magenta, purple }
      { \tl_set_eq:NN \g__txbk_color_theme_series_tl \l_keys_choice_tl },
    colortheme   / unknown .code:n = 
      { \msg_error:nn { textbook } { invalid-colortheme } },
    colortheme   .initial:n   = azure,
    txconfig  .tl_set:N = \g__txbk_config_filename_tl,
    unknown .code:n   = { \msg_error:nn { textbook } {unknown-option} }
  }
\msg_new:nnn { textbook } { unknown-option }
  { Package~option~`\l_keys_key_tl'~is~unknown. }
\msg_new:nnn { textbook } { invalid-colortheme }
  { The~value~which~you~set~for~the~key~`\l_keys_choice_tl'~is~invalid. ~Use~`red',~`olive',~`azure',~`violet'~or~`purple'~instead.}
\ProcessKeysOptions { txbk / option }
\PassOptionsToClass { 
    zihao = -4,
    % sub4section,
    \g__txbk_to_ctexbook_clist 
    } { ctexbook }
\LoadClass { ctexbook }

% -----------------------------------------------------------------------------
% 文档调用的宏包
% -----------------------------------------------------------------------------
% \PassOptionsToPackage{ table }{ xcolor }
\RequirePackage
  {
    amsmath,
    amssymb,
    amsfonts,
    upgreek,
    ntheorem,
    xpatch,
    xfrac,
    ninecolors,
    printlen,
    ean13isbn,
    fontawesome5,
    qrcode,
    varwidth,
    geometry,
    fancyhdr,
    caption,
    subcaption,
    tabularray,
    xeCJKfntef,
    csvsimple-l3,
    tasks,
    hyperref,
    cleveref,
  }
\RequirePackage[ user, abspage, lastpage ]{ zref }
\RequirePackage[perpage]{footmisc}
% -----------------------------------------------------------------------------
% 抑制 ctex 包字体重定义的警告信息
% -----------------------------------------------------------------------------
\xpatchcmd\__xeCJK_check_family:n{\__xeCJK_warning:nxx}{\__xeCJK_info:nxx}{}{}
% -----------------------------------------------------------------------------
% 键值对设计
% -----------------------------------------------------------------------------
\keys_define:nn { txbk / style }
  {
    fullwidth-stop .choice:,
    fullwidth-stop .value_required:n = true,
    fullwidth-stop / catcode .code:n =
      {
        \__txbk_set_fullwidth_stop_catcode:
      },
    fullwidth-stop / false .code = { },
    boldemph .bool_set:N = \g__txbk_emph_bold_bool,
    boldemph .initial:n = false
  }
\cs_new:Npn \__txbk_set_fullwidth_stop_catcode:
  {
    \char_set_active_eq:NN ^^^^3002 \c__txbk_fwid_full_stop_tl
    \char_set_catcode_active:N ^^^^3002
  }
\keys_set:nn { txbk / style }
  {
    fullwidth-stop = false
  }
\keys_define:nn { txbk }
  {
    BookTitle       .tl_set:N     = \g__txbk_book_title_zh_tl,
    BookTitle       .initial:n    = { 非常长长长长长长长长长长长长的书名 },
    BookTitle*      .tl_set:N     = \g__txbk_book_title_en_tl,
    BookTitle*      .initial:n    = { A~Very~Long~Long~Long~Long~Long~Long~Title },
    SubTitle        .tl_set:N     = \g__txbk_book_subtitle_zh_tl,
    SubTitle*       .tl_set:N     = \g__txbk_book_subtitle_en_tl,
    Edition         .int_set:N    = \g__txbk_book_edition_int,
    EditionStr      .str_set:N    = \g__txbk_book_edition_str,
    BookSeries      .tl_set:N     = \g__txbk_book_series_zh_tl,
    BookSeries*     .tl_set:N     = \g__txbk_book_series_en_tl,
    BriefIntro      .tl_set:N     = \g__txbk_brief_introduction_tl,
    BriefIntro      .initial:n    = { 这本书的简介。 },
    AuthorList      .clist_set:N  = \g__txbk_book_author_zh_clist,
    AuthorList*     .clist_set:N  = \g__txbk_book_author_en_clist,
    WrittenStyle    .str_set:N    = \g__txbk_written_style_str,
    WrittenStyle    .initial:n    = { 著 },
    DedicatedTo     .tl_set:N     = \g__txbk_dedicated_to_tl,
    Publisher       .tl_set:N     = \g__txbk_publisher_tl,
    Publisher       .initial:n    = { 同济极客出版社 },
    Logo            .tl_set:N     = \g__txbk_pub_logo_tl,
    Logo            .initial:n    = { logo.pdf },
    CoverGraph      .tl_set:N     = \g__txbk_cover_graph_tl,
    CoverGraph      .initial:n    = { cvgraph.pdf },
    Url             .str_set:N    = \g__txbk_url_str,
    Url             .initial:n    = {http://www.tjad.cn},
    Editor          .tl_set:N     = \g__txbk_editor_tl,
    Editor          .initial:n    = { 张晨南 },
    Designer        .tl_set:N     = \g__txbk_designer_tl,
    Designer        .initial:n    = { 张晨南 },
    Statement       .tl_set:N     = \g__txbk_statement_tl,
    Statement       .initial:n    = { 本书只用于个人学习交流，严禁用于商业用途 },
    ReleaseDate     .code:n       =
      { 
        \tl_set:Nx \g__txbk_release_date_tl
          { \__txbk_date_parse:n { #1 } }
      },
    PrintDate       .code:n       =
      { 
        \tl_set:Nx \g__txbk_print_date_tl
          { \__txbk_date_parse:n { #1 } }
      },
    ISBN            .str_set:N    = \g__txbk_isbn_str,
    Price           .tl_set:N     = \g__txbk_price_tl,
    style           .meta:nn      = { txbk / style } {#1}
    % Price           .initial:n    = { 358.00 }
  }
% -----------------------------------------------------------------------------
% tikz 与 tcolorbox 设置
% -----------------------------------------------------------------------------
\RequirePackage{tikz}
\RequirePackage{tcolorbox}
\tcbuselibrary{skins,breakable,raster,listings,xparse}
\tcbset
  {
    skin = enhanced,
    screen/.style =
    {
		  top            = 1mm,
      bottom         = 0mm,
      boxsep         = 0mm,
		  colback        = black!75!white,
		  colframe       = yellow!75!black,
		  fontlower      = \small\ttfamily,
		  fontupper      = \small\ttfamily,
		  listing~engine = listings,
		  breakable
	  },
    osshell/.style = 
    {
      screen,
      listing~only,
		  every~listing~line = { \textcolor{green}{\bfseries \$ ~ > } },
		  listing~options    =
        { 
          language={#1},
          breaklines,
          postbreak = \mbox{\textcolor{red}{$\hookrightarrow$}\space},
          style=dark 
        },
	  },
    codeexample/.style=
    {
		  breakable,
		  sharp~corners,
		  colback      = genbgl!20,
		  colbacktitle = genfg,
		  coltitle     = white,
		  colframe     = genfg,
		  top          = 0mm,
      bottom       = 0mm,
      boxsep       = 0mm
	  },
    alertbox/.style = 
    {
		  sidebyside,
      segmentation~hidden,
		  fontupper     = \huge,
		  fontlower     = \small,
      colback       = #1!20, 
      colupper      = #1!50!black,
		  lefthand~width= 9mm,
		  arc           = 2mm,
		  fuzzy~shadow  = {1mm}{-1mm}{0mm}{0.1mm}{black!50!white}
    },
    deduction/.style=
    {
      before~skip  = 5pt,
      after~skip   = 5pt,
      colback      = genbgd!8,
      colframe     = genbgd,
      coltitle     = white,
      fonttitle    = \small\sffamily\bfseries,
      boxrule      = 0.2mm,
      arc          = 0mm,
      leftrule     = 2mm,
      attach~boxed~title~to~top~left =
        {
          xshift  = 0cm,
          yshift* = 0mm-\tcboxedtitleheight
        },
      varwidth~boxed~title* = -3cm,
      boxed~title~style=
        {
          frame~code=
            {
              \coordinate (A) at (frame.north~east);
              \coordinate (B) at (frame.south~east);
              \path[fill=genbgd](frame.north~east)
              --([xshift=-2mm]frame.north~west)
              --([xshift=-2mm]frame.south~west)
              --(frame.south~east) --([xshift=3mm]$(A)!0.5!(B)$)--cycle;
			        \draw[white,line~width=2pt]([xshift=-2mm]frame.north~east)
              --([xshift=1mm]$(A)!0.5!(B)$)--([xshift=-2mm]frame.south~east);
			        \path[fill=darkgray]([xshift=-2mm]frame.south~west)
              --+(2mm,-2mm)|-cycle;
            },
          interior~engine=empty,
        },
    },
    theorem/.style=
    {
      colframe     = genbgd,
      colback      = genbgd!8,
      sharp~corners,
      coltitle     = white,
      fonttitle    = \small\sffamily\bfseries,
      boxrule      = 0pt,
	    leftrule     = 1.4pt,
      boxed~title~style = 
        { 
          colback  = genbgd,
          boxsep   = 1pt,
          sharp~corners
        },
      attach~boxed~title~to~top~left =
        {
          yshift=-\tcboxedtitleheight,
          yshifttext=-1.05\baselineskip
        },
      overlay~unbroken~and~first=
        {
          \node[below~right,font=\small\sffamily,color=genfg,text~width=.8\linewidth]
          at (title.north~east) {#1};
        }
    },
    definition/.style=
    {
      before~skip  = 5pt,
      after~skip   = 5pt,
      colback      = genbgd!8,
      coltitle     = white,
      fonttitle    = \small\sffamily\bfseries,
      colframe     = genbgd,
      boxrule      = 0.2mm,
      arc          = 0mm,
      attach~boxed~title~to~top~left =
        {
          xshift  = -4mm,
          yshift* = -0.5mm
        },
      boxed~title~style=
        {
          empty,
          arc       = 0pt,
          outer~arc = 0pt,
          boxrule   = 0pt
        },
      underlay~boxed~title={
          \fill[genbgd] 
          (title.north~west) -- 
          (title.north~east) -- 
          +(\tcboxedtitleheight-1mm,-\tcboxedtitleheight+1mm) -- 
          ([xshift=4mm,yshift=0.5mm]frame.north~east) -- 
          +(0mm,-1mm) -- 
          (title.south~west) -- cycle;
          \fill[darkgray] 
          ([yshift=-0.5mm]frame.north~west) -- 
          +(-0.4,0) -- 
          +(0,-0.3) -- cycle;
          \fill[darkgray] 
          ([yshift=-0.5mm]frame.north~east) -- 
          +(0,-0.3) -- 
          +(0.4,0) -- cycle; 
        },
    },
    practice/.style={
      breakable,
      sharp~corners,
      coltitle     =  genfg,
      fonttitle    = \small\sffamily\bfseries,
      colbacktitle =  genbgd!20,
      colback      =  genbgd!8,
      colframe     =  genbgd!50,
      top          =  2ex,
      varwidth~boxed~title = 0.7\linewidth,
      attach~boxed~title~to~top~left =
        {
          xshift  = -3mm,
          yshift  = -\tcboxedtitleheight/2
        },
      boxed~title~style=
        {
          sharp~corners, 
          boxrule = 0pt
        },
      underlay~boxed~title=
        {
          \fill[genbgd!20] (title.south~west) -- 
            (title.south-|frame.west) --++(0,-.2*\tcboxedtitleheight)--cycle;
          \fill[genbgd!20] (title.north~east) --
          ++(-.5*\tcboxedtitleheight,0)--++(0,.2*\tcboxedtitleheight)--cycle;
        },
    },
    review/.style =
    {
      breakable,
      sharp~corners,
      coltitle     =  genfg,
      colbacktitle =  genbgd!20,
      fonttitle    = \small\sffamily,
      colback      =  genbgd!8,
      colframe     =  genbgd!50,
      top          = 2ex,
      attach~boxed~title~to~top~left =
        {
          xshift  = 0.3cm,
          yshift  = -\tcboxedtitleheight/2
        },
      boxed~title~style=
        {
          % size=small,
          colback = genbgd!20,
        }
    },
    advice/.style=
    {
      skin=enhanced,
      breakable,
      before~skip  = 10pt,
      colback      = genbgd!8,
      colframe     = genbgd!50,
      boxrule      = 0.2mm,
      fonttitle    = \bfseries\sffamily,
      colbacktitle = genbgd!50,
      attach~boxed~title~to~top~left =
        {
          xshift  = 1cm,
          yshift* = 1mm-\tcboxedtitleheight
        },
      varwidth~boxed~title* = -3cm,
      boxed~title~style=
        {
          frame~code=
            {
              \path[fill=tcbcolback!30!black]
                ([yshift=-1mm,xshift=-1mm]frame.north~west)
                arc [start~angle=0,end~angle=180,radius=1mm]
                ([yshift=-1mm,xshift=1mm]frame.north~east)
                arc [start~angle=180,end~angle=0,radius=1mm];
              \path
                [ 
                  left~color  = tcbcolback!60!black,
                  right~color = tcbcolback!60!black,
                  middle~color= tcbcolback!80!black
                ]
                ([xshift=-2mm]frame.north~west) --
                ([xshift=2mm]frame.north~east)[rounded~corners=1mm]--
                ([xshift=1mm,yshift=-1mm]frame.north~east)--
                (frame.south~east) -- (frame.south~west)--
                ([xshift=-1mm,yshift=-1mm]frame.north~west)
                [sharp~corners]-- cycle;
            },
          interior~engine=empty,
        },
    },
    exercise/.style={
      breakable,
      colframe=genbgd!80,
      colback=genbgd!8,
      colbacktitle=genbgd!20!white,
      fonttitle=\bfseries,
      coltitle=black,
      attach~boxed~title~to~top~center=
        {
          yshift=-0.25mm-\tcboxedtitleheight/2,
          yshifttext=2mm-\tcboxedtitleheight/2
        },
      boxed~title~style=
      {
        boxrule=0.5mm,
        frame~code={ 
          \path[tcb~fill~frame] ([xshift=-4mm]frame.west)
            -- (frame.north~west) -- (frame.north~east) 
            -- ([xshift=4mm]frame.east) -- (frame.south~east) 
            -- (frame.south~west) -- cycle; 
          },
        interior~code={ 
          \path[tcb~fill~interior] ([xshift=-2mm]interior.west)
            -- (interior.north~west) -- (interior.north~east)
            -- ([xshift=2mm]interior.east) -- (interior.south~east) 
            -- (interior.south~west)-- cycle;
          }
      }
    }
  }
%-------------------------------------------------------------------------------
% printlen 设置
%-------------------------------------------------------------------------------
\uselengthunit{mm}
%-------------------------------------------------------------------------------
% xeCJK设置中文样式
%-------------------------------------------------------------------------------
\xeCJKsetup{CJKecglue={\hskip 0.10em plus 0.05em minus 0.05em},CheckSingle=true}
% ------------------------------------------------------------------------------
% 字体设置
% ------------------------------------------------------------------------------
\tl_new:N \g__txbk_source_han_serif_tl
\tl_new:N \g__txbk_source_han_serif_bold_tl
\tl_new:N \g__txbk_source_han_sans_tl
\fontspec_font_if_exist:nTF { Noto~Serif~CJK~SC }
  { \tl_set:Nn \g__txbk_source_han_serif_tl { Noto~Serif~CJK~SC  } }
  { \tl_set:Nn \g__txbk_source_han_serif_tl { Source~Han~Serif~SC} }
\fontspec_font_if_exist:nTF { Noto~Sans~CJK~SC }
  { \tl_set:Nn \g__txbk_source_han_sans_tl { Noto~Sans~CJK~SC  } }
  { \tl_set:Nn \g__txbk_source_han_sans_tl { Source~Han~Sans~SC} }
\tl_set_eq:NN \g__txbk_source_han_serif_bold_tl \g__txbk_source_han_serif_tl
\tl_put_right:Nn \g__txbk_source_han_serif_bold_tl { ~Bold }
\setCJKmainfont{ \g__txbk_source_han_serif_tl }
  [
    UprightFont = *~Light,
    BoldFont    = *~SemiBold,
    % ItalicFont  = LXGWWenKai
  ]
\setCJKsansfont{ \g__txbk_source_han_sans_tl }
  [
    UprightFont = *,
    BoldFont    = *~Medium
  ]
\setCJKmonofont{ Sarasa~Term~SC~Nerd }

\newfontfamily\roboto{ RobotoCondensed }
  [ 
    Extension   = .otf,
    UprightFont = *-Regular,
    BoldFont    = *-Bold ,
    ItalicFont  = *-Italic
  ]
\setCJKfamilyfont { zhxwwk } { LXGWWenKai }
  [
    Extension   = .ttf,
    UprightFont = *-Regular,
    ItalicFont  = *-Regular,
    BoldFont    = *-Bold 
  ]
\newcommand{\xwwk}{\CJKfamily+{zhxwwk}}
\setCJKfamilyfont{zhcusong}{ \g__txbk_source_han_serif_bold_tl }
\newcommand{\cusong}{\CJKfamily+{zhcusong}}
% ------------------------------------------------------------------------------
% 额外的配置文件读取
% ------------------------------------------------------------------------------
\tl_if_empty:NF \g__txbk_config_filename_tl
  {
    \IfFileExists{\tl_use:N \g__txbk_config_filename_tl}
      { \file_input:x {\tl_use:N \g__txbk_config_filename_tl} }
      { \relax }
  }
% ------------------------------------------------------------------------------
% 页面设置
% ------------------------------------------------------------------------------
\geometry
  {
    inner      = 2.5 cm ,
    outer      = 4.0 cm ,
    top        = 3.5 cm ,
    bottom     = 5 cm   ,
    headheight = 15 pt  ,
  }
% ------------------------------------------------------------------------------
% 页眉页脚设计
% ------------------------------------------------------------------------------
\renewcommand{\headrulewidth}{0mm}
\pagestyle{fancy}
\fancyhf{}
\fancyhead[LE]{
  \begin{tikzpicture}[overlay,remember~picture]
    \draw [line~width=0.5pt,genfg] 
      ([xshift=3.8cm,yshift=-3.0cm]current~page.north~west) --++(0,3.0cm);
    \node at ([xshift=3.6cm,yshift=-3.0cm]current~page.north~west) 
      [above~left]{\small\thepage};
    \node at ([xshift=4cm,yshift=-3.0cm]current~page.north~west) 
      [above~right]{\small\leftmark};
  \end{tikzpicture}
}
\fancyhead[RO]{
  \begin{tikzpicture}[overlay,remember~picture]
    \draw[line~width=0.5pt,genfg]
      ([xshift=-3.8cm,yshift=-3.0cm]current~page.north~east)--++(0,3.0cm);
    \node at ([xshift=-3.6cm,yshift=-3.0cm]current~page.north~east)
      [above~right]{\small\thepage};
    \node at ([xshift=-4cm,yshift=-3.0cm]current~page.north~east) 
      [above~left]{\small\rightmark};
  \end{tikzpicture}
}
\fancypagestyle{plain}{\fancyhf{}}
%-------------------------------------------------------------------------------
% 脚注改为中文带圈数字脚注方式
%-------------------------------------------------------------------------------
\RequirePackage{xpatch}
\newcommand{\circlenumber}[1]{%
\ifnum #1<21
  \edef\a{\the\numexpr #1+9311}
\else
  \ifnum #1<36
    \edef\a{\the\numexpr #1+12860}
  \else
    \ifnum #1<51
     \edef\a{\the\numexpr #1+12941}
    \else
      \PackageError{popularsym}%
      {Number~is~too~big!}{The~Number~should~be~not~Greater~than~50}
    \fi
  \fi
\fi
{\CJKfontspec{ \g__txbk_source_han_serif_tl }\fontspec{ \g__txbk_source_han_serif_tl }\symbol\a}}
\renewcommand{\thefootnote}{\protect\circlenumber{\arabic{footnote}}}
%-------------------------------------------------------------------------------
% 数学定理定义环境设置
%-------------------------------------------------------------------------------
\theoremseparator{\,}
\theorembodyfont{\rmfamily}
\newtheorem{example}{\bfseries 例}[chapter]
\newenvironment{solution}{\noindent {\bfseries 解：}}{}
\newenvironment{analyze}{\noindent {\bfseries 分析：}}{}
\newenvironment{rmk}{\noindent {\bfseries 注意：}}{}
\newenvironment{note}{\noindent {\bfseries 说明：}}{}
\DeclareTColorBox{blk}{O{} m}
  {
    advice, title={#2},#1
  }
\DeclareTColorBox{ex}{O{}}
  {
    exercise, title={练习},#1
  }
\DeclareTColorBox{ Definition}{     }{ definition, title={定义} }
\DeclareTColorBox{ Deduction }{ m   }{ deduction,  title={#1} }
\DeclareTColorBox{ Theorem   }{ O{} m O{} }{ theorem=#1, title={#2},#3 }
\renewcommand{\proofname}{\bfseries 证明：}
\newenvironment{proof}{{\noindent \bfseries 证明：}}{}%{\hfill $\square$\par}
\DeclareMathOperator{\arccot}{arccot}
%-------------------------------------------------------------------------------
% 习题命令
%-------------------------------------------------------------------------------
% \newcounter{exer}[chapter]
% \newcommand\Exercise{
%   \refstepcounter{exer}
%   \section*{习题~\arabic{chapter}.\arabic{exer}}
%   \addcontentsline{toc}{subsection}{习题~\arabic{chapter}.\arabic{exer}}
% }
%-------------------------------------------------------------------------------
% 浮动体内容默认采用小号字并居中
%-------------------------------------------------------------------------------
\xpatchcmd\@floatboxreset{\normalsize}{\centering\small}{}{}
%-------------------------------------------------------------------------------
% \includegraphics 图片的默认路径。
%-------------------------------------------------------------------------------
\graphicspath{{./figures/}{./graphics/}}
%-------------------------------------------------------------------------------
% 普通列表定义 已说明
%-------------------------------------------------------------------------------
\RequirePackage[shortlabels,inline]{enumitem}
\setlist{nosep,listparindent=2em}
\newlist{question}{enumerate}{2}
\setlist[question,1]{label=\arabic*.,ref=\arabic*}
\setlist[enumerate]{itemindent=3.5em}
% \setlist[itemize]{itemindent=2.0em}
\setlist[enumerate,1]{leftmargin=0em,label=(\arabic*)}
\setlist[enumerate,2]{leftmargin=1em,label=(\alph*)}
\setlist[enumerate,3]{leftmargin=1em,label=\roman*)}
\setlist[description]{labelindent=\parindent}
\settasks{label-width=15pt,after-item-skip=0pt,before-skip=1pt,after-skip=1pt}
%-------------------------------------------------------------------------------
% 设置图表标题形式
%-------------------------------------------------------------------------------
\captionsetup{
  labelsep     = quad,
  font         = { small, sf },
  skip         = 5pt,
  subrefformat = parens,
  hypcap       = false
}
%-------------------------------------------------------------------------------
% 设置表格样式
%-------------------------------------------------------------------------------
\UseTblrLibrary{siunitx}
\SetTblrInner{
  hlines        = { genfg },
  vlines        = { genfg },
  hline{ 1, Z } = { 1.5 pt, genfg },
  vline{ 1, Z } = { 1.5 pt },
  rows          = { m },
  rowsep        = 1pt
}
\NewTblrTheme { plain }
{
  \SetTblrTemplate{head,contfoot}{empty}
  \SetTblrStyle{note,remark}{\footnotesize}
}
\DefTblrTemplate{conthead-text}{normal}{（续）}
\DefTblrTemplate{ caption-sep }{ normal }{ \quad }
\NewTblrTheme { normal }
{
  \SetTblrTemplate{contfoot}{empty}
  \SetTblrTemplate{conthead-text}{normal}
  \SetTblrStyle{note,remark}{\footnotesize\rmfamily}
  \SetTblrStyle{caption-tag,caption-sep,caption-text,conthead-text}{\small\sffamily}
}
%-------------------------------------------------------------------------------
% 浮动图表规则放松
%-------------------------------------------------------------------------------
\setcounter{topnumber}{4}
\setcounter{bottomnumber}{4}
\setcounter{totalnumber}{10}
\renewcommand{\textfraction}{0.15}
\renewcommand{\topfraction}{0.85}
\renewcommand{\bottomfraction}{0.70}
\renewcommand{\floatpagefraction}{0.66}
%-------------------------------------------------------------------------------
% 浮动图表默认位置规则
%-------------------------------------------------------------------------------
\def\fps@figure{htbp}
\def\fps@table{htbp}
%-------------------------------------------------------------------------------
% 重定义目录，给目录加标签
%-------------------------------------------------------------------------------
\renewcommand\tableofcontents
  {
    \if@twocolumn
      \@restonecoltrue\onecolumn
    \else
      \@restonecolfalse
    \fi
    \chapter*{\contentsname}
    \@mkboth{\MakeUppercase\contentsname}{\MakeUppercase\contentsname}
    \pdfbookmark{目录}{contents}
    \@starttoc{toc}
    \if@restonecol\twocolumn\fi
  }
% ------------------------------------------------------------------------------
% siunitx 设置
% ------------------------------------------------------------------------------
\RequirePackage{siunitx}
\sisetup{
  separate-uncertainty,
  retain-explicit-plus=true,
  list-final-separator = {\nobreakspace 和 \nobreakspace},
  list-pair-separator  = {\nobreakspace 和 \nobreakspace},
  list-separator = {、},
  range-phrase   = {～}
}
% ------------------------------------------------------------------------------
% hyperref 和 cleveref 设置
% ------------------------------------------------------------------------------
\RequirePackage{hyperref,cleveref}
\hypersetup
  {
    colorlinks         = true   ,
    linkcolor          = teal2  ,
    citecolor          = brown2 ,
    urlcolor           = blue2  ,
    bookmarksnumbered  = true   ,
    bookmarksopen      = false  ,
  }
\crefname{equation}{式}{式}
\crefname{figure}{图}{图}
\crefname{table}{表}{表}
\crefname{example}{例}{例}
\crefname{practice}{}{}
\crefname{appendix}{附录}{附录}
\crefname{chapter}{}{}
\crefname{section}{}{}
\crefname{subsection}{}{}
\crefname{subsubsection}{}{}
\crefname{paragraph}{}{}
\crefname{subparagraph}{}{}
\crefname{page}{}{}
\creflabelformat{chapter}{#2第 #1 章#3}
\creflabelformat{question}{#2第 #1 题#3}
\creflabelformat{practice}{#2练习 #1#3}
\creflabelformat{section}{#2第 #1 节#3}
\creflabelformat{subsection}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{subsubsection}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{paragraph}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{subparagraph}{#2第\nobreakspace #1\nobreakspace 节#3}
\creflabelformat{page}{#2第\nobreakspace #1\nobreakspace 页#3}
\newcommand{\crefpairconjunction}{\nobreakspace 和 \nobreakspace}
\newcommand{\crefmiddleconjunction}{、}
\newcommand{\creflastconjunction}{\nobreakspace 和 \nobreakspace}
\newcommand{\crefpairgroupconjunction}{\nobreakspace 与 \nobreakspace}
\newcommand{\crefmiddlegroupconjunction}{、}
\newcommand{\creflastgroupconjunction}{\nobreakspace 与 \nobreakspace}
\newcommand{\crefrangeconjunction}{～}
% ------------------------------------------------------------------------------
% 数学符号重定义
% ------------------------------------------------------------------------------
\cs_new:Npn \__txbk_symbols_symbol_four_size:n #1
  {
    \mathchoice
      {
        \hbox:n 
          {
            \fontsize{\tf@size}{\tf@size}\selectfont #1
          }
      }
      {
        \hbox:n 
          {
            \fontsize{\tf@size}{\tf@size}\selectfont #1
          }
      }
      {
        \hbox:n
          {
            \fontsize{\sf@size}{\sf@size}\selectfont #1
          }
      }
      {
        \hbox:n
          {
            \fontsize{\ssf@size}{\ssf@size}\selectfont #1 
          }
      }
  }
% 平行四边形
\fp_new:N   \l__txbk_symbols_parallelogram_angle_fp
\fp_set:Nn  \l__txbk_symbols_parallelogram_angle_fp {67}
\dim_new:N  \l__txbk_symbols_parallelogram_x_dim
\dim_set:Nn \l__txbk_symbols_parallelogram_x_dim {0.9em}
\dim_new:N  \l__txbk_symbols_parallelogram_y_dim
\dim_set:Nn \l__txbk_symbols_parallelogram_y_dim {0.7em}

\cs_new:Npn \__txbk_symbols_parallelogram:
  {
    \begin{tikzpicture}[baseline]
      \draw[line~join = round] (0,0) --++ (\l__txbk_symbols_parallelogram_x_dim,0) --++ (\fp_use:N \l__txbk_symbols_parallelogram_angle_fp \c_colon_str \l__txbk_symbols_parallelogram_y_dim) -- (\fp_use:N \l__txbk_symbols_parallelogram_angle_fp \c_colon_str \l__txbk_symbols_parallelogram_y_dim) -- cycle;
    \end{tikzpicture}
  }
% 平行
\fp_new:N   \l__txbk_symbols_parallel_angle_fp
\fp_set:Nn  \l__txbk_symbols_parallel_angle_fp {60}
\dim_new:N  \l__txbk_symbols_parallel_length_dim
\dim_set:Nn \l__txbk_symbols_parallel_length_dim {0.98em}
\dim_new:N  \l__txbk_symbols_parallel_twoline_distance_dim
\dim_set:Nn \l__txbk_symbols_parallel_twoline_distance_dim {0.28em}

\cs_new:Npn \__txbk_symbols_parallel:
  {
    \begin{tikzpicture}[baseline=0.5pt]
      \draw[line~cap = round] (0, 0) --++ (\fp_use:N \l__txbk_symbols_parallel_angle_fp \c_colon_str \l__txbk_symbols_parallel_length_dim)
      (\l__txbk_symbols_parallel_twoline_distance_dim, 0) --++ (\fp_use:N \l__txbk_symbols_parallel_angle_fp \c_colon_str \l__txbk_symbols_parallel_length_dim);
    \end{tikzpicture}
  }
% 全等
\cs_new:Npn \__txbk_symbols_cong:
  {
    \begin{tikzpicture}[line~cap=round, baseline]
      \draw
        (-.2em,1.35ex) 
          .. controls (-.46em,1.6ex) and (-.54em,.65ex) .. (-.25em,.65ex)
          .. controls (-.06em,.65ex) and (.06em,1.35ex) .. (.25em,1.35ex)
          .. controls (.54em,1.35ex) and (.46em,.4ex) .. (.2em,.65ex)
        (-.46em,.4ex) -- (.46em,.4ex)
        (-.46em,0ex) -- (.46em,0ex);
    \end{tikzpicture}
  }
% 相似
\cs_new:Npn \__txbk_symbols_sim:
  {
    \begin{tikzpicture}[line~cap=round, line~width = 0.6pt,baseline = {([yshift = -1pt]current~bounding~box.south)}]
      \draw
        (-.25em,1.15ex) 
          .. controls (-.55em,1.15ex) and (-.51em,.23ex) .. (-.275em,.23ex) 
          .. controls (0,.23ex) and (0,1.15ex) .. (.275em,1.15ex) 
          .. controls (.51em,1.15ex) and (.55em,.23ex) .. (.25em,.23ex);
    \end{tikzpicture}
  }
% ------------------------------------------------------------------------------
% 内部宏命令定义
% ------------------------------------------------------------------------------
% ---- 盒子
\cs_generate_variant:Nn \tl_map_inline:nn { xn }
\cs_new_protected:Npn \__txbk_spread_box:nn #1#2
  {
    \mode_leave_vertical:
    \hbox_to_wd:nn {#1}
      { \tl_map_inline:xn {#2} { ##1 \hfil } \unskip }
  }
% ---- 日期解析
\cs_new:Npn \__txbk_date_parse:n #1 
  { \__txbk__date_parse_aux:w #1 \q_stop }
\cs_new:Npn \__txbk__date_parse_aux:w #1-#2-#3 \q_stop 
  { #1 年 \int_eval:n {#2} 月 \int_eval:n {#3} 日 }
\cs_new_protected:Npn \txbk_set_color:nn #1#2
  {
    \colorlet { #1 } { \tl_use:N \g__txbk_color_theme_series_tl #2 }
  }
\clist_map_inline:nn
  {
    { genfg  } { 2 },
    { genbgd } { 7 },
    { genbgl } { 9 },
    { cvprim } { 3 },
    { cvsecd } { 7 },
    { cvbar  } { 1 },
    { cvpat  } { 5 },
  }
  {\txbk_set_color:nn #1}
% ---- 画 ISBN 条形码
\cs_new:Npn \__txbk_draw_barcode:n #1 { \EANisbn[SC5a,ISBN=#1] } 
\cs_new_protected:Npn \txbk_draw_barcode:
  {
    \exp_args:Nx \__txbk_draw_barcode:n \g__txbk_isbn_str
  }
% ---- 人名格式化
\cs_new:Npn \__txbk_parse_chinese_person_name_str:n #1 
  { 
    \int_compare:nNnTF { \str_count_ignore_spaces:n { #1 } } = { 2 }  
      { \quad\__txbk_spread_box:nn{3em}{ #1 } } { \quad #1  }
  }
% ---- 封面设计
\cs_new_protected:Nn \txbk_book_cover:
  {
    \begin{titlepage}
      \thispagestyle{empty}
      \pdfbookmark{封面}{cover}
      \begin{tikzpicture}[overlay, remember~picture, inner~sep=0pt]
        \fill[ cvsecd ]
          ( current~page.north~west ) rectangle ( current~page.south~east );
        \fill[ cvbar ]
          ([yshift =-4cm] current~page.center ) rectangle ( current~page.west )
          ([xshift = 2cm , yshift =-4cm] current~page.west ) 
          rectangle ( [yshift =-8cm] current~page.east );
        \fill[ cvprim ]
          ([xshift = 2cm] current~page.north~west ) 
          rectangle ([xshift = -2cm, yshift = -7.5cm] current~page.east );
        \fill[ cvprim!30 ]
          ([xshift = 2cm ] current~page.west ) rectangle(current~page.south);
        \IfFileExists {\tl_use:N \g__txbk_cover_graph_tl}
          {
            \node at ([ xshift = 2cm ] current~page.west ) 
            [anchor = north~west, opacity = 0.8]
            {
              \includegraphics [ width = \dim_eval:n{ 0.5\paperwidth - 2cm} ] 
              { \tl_use:N \g__txbk_cover_graph_tl }
            };
          }
          {\relax }
        \fill[cvpat , opacity = 0.4]
          ([xshift = 2cm , yshift =-8cm] current~page.west ) 
          rectangle ([xshift = -2cm, yshift = 2cm] current~page.south~east );
        \coordinate (logo) 
          at ([xshift = -3.5cm, yshift = 3cm] current~page.south~east );
        \IfFileExists{ \tl_use:N \g__txbk_pub_logo_tl }
          {
            \node at ( logo ) [ right ]
              { 
                \includegraphics [height=1cm] 
                  { \tl_use:N \g__txbk_pub_logo_tl } 
              };
          }
          { \relax }
        \node (publish) at (logo)
          [ left=5mm, color=cvtext ]
          { \Large\bfseries\xwwk\tl_use:N \g__txbk_publisher_tl};
        \tl_if_empty:NF \g__txbk_book_series_zh_tl 
          {
            \node (zhseries) 
            at ([xshift = -2.5cm, yshift = -2.5cm] current~page.north~east )
            [left, color=cvtext]
            { \large\sffamily\tl_use:N \g__txbk_book_series_zh_tl};
          }
        \tl_if_empty:NF \g__txbk_book_series_en_tl
          {
            \node (enseries) at ([yshift = -5mm] zhseries.south~east )
            [left, color=cvtext]
            {\large\slshape\sffamily\tl_use:N \g__txbk_book_series_en_tl};
          }
        \coordinate (linestart) 
          at ([xshift = 2.2cm ,  yshift =4.5cm] current~page.west );
        \coordinate (lineend)   
          at ([xshift = -2.2cm , yshift =4.5cm] current~page.east );
        \draw[line~width=1mm,cvtext] (linestart)--(lineend);
        \node (zhtitle) 
          at ([yshift=-5mm]linestart)
          [anchor=north~west,cvtext] 
          {
            \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
              \raggedright
              \cusong\huge\tl_use:N\g__txbk_book_title_zh_tl
            \end{varwidth}
          };
        \node (entitle) at ([yshift= 5mm]linestart)
          [anchor=south~west,cvtext] 
          {
            \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
              \raggedright
              \scshape\roboto\huge\tl_use:N\g__txbk_book_title_en_tl
            \end{varwidth}
          };
        \tl_if_empty:NF \g__txbk_book_subtitle_zh_tl 
          { 
            \node at ([yshift=-3mm]zhtitle.south~west)
              [anchor=north~west,cvtext] 
              {
                \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
                  \sffamily\Large\tl_use:N\g__txbk_book_subtitle_zh_tl
                \end{varwidth}
              }; 
          }
        \tl_if_empty:NF \g__txbk_book_subtitle_en_tl 
          { 
            \node at ([yshift=3mm]entitle.north~west)
              [anchor=south~west,cvtext] 
                {
                  \begin{varwidth}{ \dim_eval:n{ \paperwidth - 7cm}}
                    \itshape\roboto\Large\tl_use:N\g__txbk_book_subtitle_en_tl
                  \end{varwidth}
                }; 
          }
        \coordinate (decs) 
          at ([ yshift=-4.5cm, xshift=5mm  ]current~page.center);
        \coordinate (dece) 
          at ([ yshift=-3.5cm, xshift=-25mm ]current~page.east);
        \draw [ cvtext ]
          (decs)--++(3.5,0)--++(1,1)--(dece);
        \fill [ cvtext ] (decs) circle (5pt);
        \fill [ cvtext ] (dece) circle (5pt);
        \clist_if_empty:NF \g__txbk_book_author_zh_clist
          {
            \node (written )at ([yshift=-12mm] dece) [anchor=north~east,cvtext]
              { 
                \sffamily \large \bfseries 
                \str_use:N \g__txbk_written_style_str
              };
            \node at ([xshift=-5mm]written.west) [left, cvtext]
              {
                \sffamily \bfseries \large 
                \clist_map_inline:Nn \g__txbk_book_author_zh_clist
                  { \__txbk_parse_chinese_person_name_str:n {##1} } 
              };
          }
        \clist_if_empty:NF \g__txbk_book_author_en_clist
          { 
            \node at ([yshift=12mm] decs) [anchor=south~west,cvtext]
              { 
                \large\ \parbox{ \dim_eval:n{ 0.5\paperwidth - 3cm} }
                {
                  \bfseries
                  \clist_use:Nnnn \g__txbk_book_author_en_clist 
                    {\\} {\\} {\\}
                }  
              }; 
          }
        \int_compare:nNnTF { \g__txbk_book_edition_int } = { 0 }
          {
            \str_if_empty:NF \g__txbk_book_edition_str
            {
              \node at (entitle.south-|dece)
                [cvtext,anchor=south~east]
                {
                  \bfseries\slshape \large Ed.~
                  \str_use:N \g__txbk_book_edition_str
                };
              \node at (zhtitle.north-|dece) [cvtext, anchor =north~east ]
                {\large\bfseries（ \str_use:N \g__txbk_book_edition_str  版）};
            }
          }
          {
            \node at (entitle.south-|dece)
              [cvtext,anchor=south~east]
              {
                \bfseries\slshape \large Ed.~
                \int_to_Roman:n {\g__txbk_book_edition_int}
              };
            \node at (zhtitle.north-|dece) [cvtext, anchor =north~east ]
              {\large\bfseries（第 \zhnum_number:f { \int_use:N \g__txbk_book_edition_int } 版）};
          }
      \end{tikzpicture}
    \end{titlepage}
  }
% ---- 封底设计
\cs_new_protected:Nn \txbk_book_back_cover:
  {
    \thispagestyle{empty}
    \pdfbookmark{封底}{backcover}
    \begin{tikzpicture}[overlay, remember~picture, inner~sep=0pt]
      \fill[ cvsecd ]
          ( current~page.north~west ) rectangle ( current~page.south~east );
        \fill[ cvbar ]
          ([yshift =-8cm] current~page.east ) rectangle ( current~page.west );
        \fill[ cvprim ]
          ([xshift = -2cm] current~page.north~east ) 
          rectangle ([xshift = 2cm, yshift = -7.5cm] current~page.west );
        \fill[ cvprim!30 ]
          ([xshift = -2cm ] current~page.east ) rectangle(current~page.south);
        \node (editor) at ( [xshift = 2.5cm, yshift=-2.5cm] current~page.north~west )
          [cvtext,anchor=north~west]{\large\bfseries~责任编辑：\makebox[3em][s]{\tl_use:N \g__txbk_editor_tl}};
        \node (designer) at ( [yshift=-0.5cm] editor.south~west )
          [cvtext,anchor=north~west]{\large\bfseries~封面设计：\makebox[3em][s]{\tl_use:N \g__txbk_designer_tl}};
        \str_if_empty:NTF \g__txbk_isbn_str
          {
            \node (barcode) at ([xshift=-25mm,yshift=50mm]current~page.south~east)
            [cvbar,anchor=south~east]{ \fbox{\qrcode[nolink,height=4cm]{ \str_use:N \g__txbk_url_str }} };
          }
          {
            \node (barcode) at ([xshift=-25mm,yshift=50mm]current~page.south~east)
            [cvbar,anchor=south~east]{ \txbk_draw_barcode: };
          }
        \draw [cvbar,thick] ([yshift=-2mm]barcode.south~west)--([yshift=-2mm]barcode.south~east)
          node[anchor=north~east,text=cvbar,inner~sep=2mm]{\large\sffamily~定价：\tl_use:N \g__txbk_price_tl ~元};
    \end{tikzpicture}
  }
% ---- 扉页设计
\cs_new_protected:Nn \txbk_book_flypage:
{
  \begin{titlepage}
    \thispagestyle{empty}\pdfbookmark{扉页}{flypage}
    \begin{flushleft}
      \huge
      {\scshape\roboto\tl_use:N\g__txbk_book_title_en_tl}
      \par\bigskip\hrule\bigskip
      {\cusong\tl_use:N\g__txbk_book_title_zh_tl}\par
      \bigskip
    \end{flushleft}
    \begin{flushleft}
      \large\bfseries
      \clist_if_empty:NF \g__txbk_book_author_en_clist
        { \clist_use:Nnnn \g__txbk_book_author_en_clist {\\} {\\} {\\} }
      \par\bigskip
    \end{flushleft}
    \begin{flushright}
      \sffamily \large \hrule \bigskip
      \clist_if_empty:NF \g__txbk_book_author_zh_clist
        {
          \clist_map_inline:Nn \g__txbk_book_author_zh_clist
            { \__txbk_parse_chinese_person_name_str:n {##1} }
          \qquad
          \str_use:N \g__txbk_written_style_str 
        }
    \end{flushright}
    \vspace{\stretch{1}}
    \begin{center}
      \Large 
      \tl_if_empty:NF \g__txbk_dedicated_to_tl 
        { 献给：\tl_use:N \g__txbk_dedicated_to_tl}
    \end{center}
    \vspace{\stretch{1}}
    \begin{center}
      \large\xwwk\tl_use:N \g__txbk_publisher_tl
    \end{center}
    \newpage\thispagestyle{empty}
    \begin{minipage}{0.8\linewidth}
      \centerline{* ~ * ~ * \quad \__txbk_spread_box:nn{6em}{内容简介} \quad * ~ * ~ *}
      \vspace{1em}\parindent 2em \tl_use:N \g__txbk_brief_introduction_tl
    \end{minipage}
    \vfill\parindent 0em
    \__txbk_spread_box:nn{4em}{责任编辑}\quad \tl_use:N \g__txbk_editor_tl \par
    \__txbk_spread_box:nn{4em}{封面设计}\quad \tl_use:N \g__txbk_designer_tl \par
    \__txbk_spread_box:nn{4em}{出版发行}\quad \tl_use:N \g__txbk_publisher_tl \par
    \__txbk_spread_box:nn{4em}{网    址}\quad \url{\exp_args:Nc \str_use:N {g__txbk_url_str}} \par
    \__txbk_spread_box:nn{4em}{开    本}\quad \rndprintlength{\paperwidth}$\times$\rndprintlength{\paperheight} \par
    \__txbk_spread_box:nn{4em}{版    次}\quad \tl_use:N \g__txbk_release_date_tl ~ 发行 \qquad \tl_use:N \g__txbk_print_date_tl ~ 印刷\par
    \str_if_empty:NF \g__txbk_isbn_str 
      { \__txbk_spread_box:nn{4em}{书号}\quad \str_use:N \g__txbk_isbn_str \par}
    \__txbk_spread_box:nn{4em}{定    价}\quad \tl_use:N \g__txbk_price_tl ~元 \par
    \bigskip \hrule \bigskip
    \begin{center}
      （\tl_use:N \g__txbk_statement_tl）
    \end{center}
  \end{titlepage}
}
% -----------------------------------------------------------------------------
% 自定义设置
% -----------------------------------------------------------------------------
\definecolor{cvtext}{RGB}{255,251,240}
\definecolor{AppleRed}{RGB}{255,95,86}
\definecolor{AppleYellow}{RGB}{255,189,46}
\definecolor{AppleGreen}{RGB}{39,201,63}
\definecolor{ogray}{RGB}{148,147,141}
\definecolor{oorange}{RGB}{233,101,56}
\definecolor{termimal}{RGB}{80,78,70}
\tl_if_empty:NT \g__txbk_release_date_tl 
  {
    \tl_set:Nn \g__txbk_release_date_tl 
      {\the\year 年\the\month 月\the\day 日}
  }
\tl_if_empty:NT \g__txbk_print_date_tl 
  {
    \tl_set:Nn \g__txbk_print_date_tl 
      {\the\year 年\the\month 月\the\day 日}
  }

\ctex_at_end_preamble:n
  {
    \hypersetup{
      pdftrapped    = true,
      pdftitle      = \tl_use:N \g__txbk_book_title_zh_tl,
      pdfcreator    = XeLaTeX,
      pdfpagelayout = TwoPageRight,
      pdfauthor     = \clist_use:Nnnn\g__txbk_book_author_zh_clist{~}{~}{~},
      pdfdisplaydoctitle = true,
    }
    \xpatchcmd\footnoterule{.4\columnwidth}{1in}{}{}
    \xpatchcmd\@makefntext{{\hss\@makefnmark}}{{\hss\@makefnmarkNormal}\space}{}{}
    \def\@makefnmarkNormal{\lower .1ex\hbox{\normalfont\@thefnmark}}
    \tl_if_empty:NT \g__txbk_price_tl
      { \tl_set:Nn \g__txbk_price_tl { \zref[abspage]{LastPage} .00} }
    \usetikzlibrary{patterns,calc}
    \bool_if:NTF \g__txbk_emph_bold_bool
      { \DeclareEmphSequence{\bfseries,\mdseries} }
      { \DeclareEmphSequence{\itshape\xwwk,\upshape\CJKfamily { \CJKfamilydefault } } }
  }
% -----------------------------------------------------------------------------
% 用户命令定义
% -----------------------------------------------------------------------------
\NewDocumentCommand \Booksetup     { m } 
  {\keys_set:nn { txbk } { #1 }}
\NewDocumentCommand \stylesetup     { m } 
  { \keys_set:nn { txbk / style } { #1 }}
\NewDocumentCommand \Concept     { m } 
  { { \bfseries\sffamily #1 } }

\NewDocumentCommand \makecover     {   } 
  { \txbk_book_cover: \global\let\makecover\relax }
\NewDocumentCommand \makeflypage   {   } 
  { \txbk_book_flypage: \global\let\makeflypage\relax }
\NewDocumentCommand \makebackcover {   } 
  { 
    \clearpage
    \bool_if:NT \g__txbk_twoside_bool
      {
        \int_if_odd:nT \c@page
          { \hbox:n { } \thispagestyle { empty } \newpage }
      }
    \txbk_book_back_cover: 
    \global\let\makebackcover\relax
  }
\RenewDocumentCommand \cleardoublepage { }
  {
    \clearpage
    \bool_if:NT \g__txbk_twoside_bool
      {
        \int_if_odd:nF \c@page
          { \hbox:n { } \thispagestyle { empty } \newpage }
      }
  }
%% --- 公式符号解释环境
\newcounter{qlst}
\NewDocumentEnvironment {EqDesc} { O{式中：} m}
  {
    \xpatchcmd{\@trivlist}{\topsep}{0pt}{}{}
    \xpatchcmd{\@trivlist}{\partopsep}{0pt}{}{}
    \begin{ list } { }
      {
        \usecounter{qlst}
	      \settowidth{\labelwidth}{#1\ensuremath{#2}\ --- \ }
	      \setlength{\labelsep}{0pt}
        \setlength{\leftmargin}{\labelwidth}
        \setlength{\rightmargin}{0em}
        \setlength{\parsep}{0ex}
        \setlength{\itemsep}{0ex}
        \setlength{\itemindent}{0em}
        \setlength{\listparindent}{0em}
        \renewcommand{\makelabel}[1]
          {
            \stepcounter{qlst}
            \int_compare:nNnTF {\value{qlst}} > {1}
              {\hfill\ensuremath{##1}\ --- \ }
              {#1\hfill\ensuremath{##1}\ --- \ }
          }
      }
  }
  { \end { list } }
%% --- 非浮动图表
\DeclareDocumentEnvironment{figurehere}{ }
  {\def\@captype{figure}\begin{center}\small}
  {\end{center}}
\DeclareDocumentEnvironment{tablehere}{ }
  {\def\@captype{table}\begin{center}\small}
  {\end{center}}

%% --- 阅读材料、复习、练习、习题
\DeclareDocumentEnvironment { Reading } { O{ 阅读材料：} m }
  { \begin{ tcolorbox }[ advice, title={#1#2}, fontupper=\small ]\parindent2em }
  { \end{ tcolorbox } }
\DeclareDocumentEnvironment { Review } { O{ 复习题 } }
  { \begin{ tcolorbox }[ review, title={\faLightbulb \nobreakspace #1}, fontupper=\small ]\parindent2em }
  { \end{ tcolorbox } }
\newcounter{practice}[chapter]
\renewcommand{\thepractice}{\chinese{practice}}
\DeclareDocumentEnvironment { Practice } { s O{ 练习 } }
  { 
    \IfBooleanTF#1
      { \tcbset { title = \faSearch \nobreakspace #2 } }
      { 
        \refstepcounter {practice}
        \tcbset { title = \faSearch \nobreakspace #2 \chinese{practice} } 
      }
    \begin{ tcolorbox }[ practice, fontupper=\small ]\parindent2em }
  { \end{ tcolorbox } }

\DeclareDocumentEnvironment { Exercise } { O{ 习题 } }
  { \begin{ tcolorbox }[ exercise, title={\faEdit \nobreakspace #1}, fontupper=\small ]\parindent2em }
  { \end{ tcolorbox } }

%% --- 信息、警告、贴士、错误 信息框
\DeclareTotalTColorBox{ \alertwarning } { +m }
  { alertbox = orange } { \centering\faExclamationTriangle \tcblower #1 }
\DeclareTotalTColorBox{ \alertinfo } { +m } 
  { alertbox = blue } { \centering\faInfoCircle \tcblower #1 }
\DeclareTotalTColorBox{\alerttip} { +m } 
  { alertbox = green } { \centering\faCheckCircle \tcblower #1 }
\DeclareTotalTColorBox{\alerterror} { +m } 
  { alertbox = red } { \centering\faTimesCircle \tcblower #1 }
\DeclareTotalTColorBox{\alertupdate} { +m } 
  { alertbox = cyan } { \centering\faArrowCircleUp \tcblower #1 }
%% --- 系统变量盒子
\DeclareTotalTCBox{ \osvar }{ m }
  { smallbox  = olive, fontupper = \sffamily }
  { #1 }
\DeclareTotalTCBox{ \oscommand }{ m }
  { smallboxdark  = olive  }
  { #1 }
%% --- shell 命令行格式
% \newtcblisting{oscmd}{osshell=\$}
\DeclareTCBListing{ oscmd }{ O{command.com} }
{  osshell=#1 }
%% --- 字符串样式
\NewDocumentCommand\Str { m } { \texttt{#1} }
%% --- 文件名及扩展名的格式
\NewDocumentCommand\fname { m }
  { \scalebox{ 0.8 } {\faFile*[regular]} \nobreakspace\texttt{ #1 } }
%% --- 编程语言参数解释环境
\NewDocumentEnvironment{ argdesc }{ O{9em} }
  {
    \begin{description}
      [
        style     = nextline,
        leftmargin= #1,
        font      = \mdseries
      ]
  }
  { \end{description} }
%% --- 落款格式
\NewDocumentCommand { \Inscribe }{ o m }
  {
    \par\vspace*{2em}
    \begin{flushright}
      --- ~ #2 \hspace*{4em}\mbox{}
      \IfNoValueF {#1} {\par #1 \hspace{2em}} 
    \end{flushright}\par
  }
\NewDocumentCommand { \CInscribe } { o m }
  {
    \par\vspace*{2em}
    \begin{flushright}
      { #2 } \hspace*{ 4.5em }\mbox{}\par
      \IfNoValueTF {#1} 
        {  
          #1 \hspace{2em}\mbox{}
        } 
        { 
          \tl_set:Nx \l_tmpa_tl { \__txbk_date_parse:n { #1 } } 
          \tl_use:N \l_tmpa_tl \hspace{2em}\mbox{}
        } 
    \end{flushright}\par
  }
\NewDocumentCommand \pnme { m } { \textsc { #1 } }
\NewDocumentCommand \pnmc { s m } 
  {
    \IfBooleanTF#1
      { \setlength \fboxsep { 1pt } \fbox{ #2 } }
      { \mbox{ #2 } }
  }
\NewDocumentCommand \Pnmc { s m } 
  {
    \IfBooleanTF#1
      { 
        \setlength \fboxsep { 1pt }
        \int_compare:nNnTF { \str_count_ignore_spaces:n { #2 } } = { 2 } 
          { \framebox[3em][s]{ #2 } }
          { \fbox{ #2 } }
      }
      { 
        \int_compare:nNnTF { \str_count_ignore_spaces:n { #2 } } = { 2 }
          { \makebox[3em][s]{ #2 } }
          { \mbox{ #2 } }
      }
  }
%% 直立微分算子
\newcommand*{\dif}{\mathop{}\!\mathrm{d}}
%% 大小写罗马数字
\NewDocumentCommand\MyRoman{ m } {\int_to_Roman:n {#1}}
\NewDocumentCommand\Myroman{ m } {\int_to_roman:n {#1}}
% ------------------------------------------------------------------------------
% 启动执行
% ------------------------------------------------------------------------------
\AtBeginDocument{ \makecover\makeflypage }
\AtEndDocument{ \makebackcover }
%-------------------------------------------------------------------------------
\endinput