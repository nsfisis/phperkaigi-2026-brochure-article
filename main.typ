#import "@preview/cades:0.3.1": qr-code
#import "@preview/codly:1.3.0": *

#set text(lang: "ja")
#let text_font = (
  family: "BIZ UDPGothic",
  size: 8.5pt
)
#let code_font = (
  family: "UDEV Gothic 35",
  size: 8pt
)

#set page(
  width: 210mm,
  height: 297mm,
  margin: (
    top: 20mm,
    bottom: 23mm,
    inside: 20mm,
    outside: 22mm,
  ),
  columns: 2
)
#set columns(gutter: 10mm)

#set text(font: text_font.family, size: text_font.size)
#show raw: set text(font: code_font.family, size: code_font.size)

#set par(leading: 0.9em)

#set raw(theme: none)
#show raw.where(block: false): it => {
  h(1pt)
  box(
    fill: luma(240),
    inset: (x: 3pt, y: 0pt),
    outset: (y: 3pt),
    radius: 2pt,
    it,
  )
  h(1pt)
}

#show: codly-init.with()
#codly(
  breakable: false,
  lang-format: none,
  number-format: none,
  fill: luma(250),
  stroke: 1pt + luma(240),
)

#let file(name, content) = {
  v(0.5em)
  block(
    width: 100%,
    stroke: luma(240),
    radius: 3pt,
    clip: true,
    {
      block(
        width: 100%,
        stroke: luma(230),
        fill: none,
        inset: (x: 6pt, y: 6pt),
        below: 0pt,
        align(center, text(font: code_font.family, size: code_font.size, strong(name))),
      )
      block(
        width: 100%,
        inset: 0pt,
        above: 0pt,
        local.with(stroke: none, radius: 0pt)(content)
      )
    },
  )
}

#show heading.where(level: 1): it => {
  block(
    width: 100%,
    inset: (bottom: 0.4em),
    stroke: (bottom: 2pt + luma(80)),
    text(size: 13pt, weight: "bold", it.body)
  )
}
#show heading.where(level: 2): it => {
  block(
    width: 100%,
    inset: (left: 0.6em, y: 0.2em),
    stroke: (left: 3pt + luma(120)),
    text(size: 10pt, weight: "bold", it.body)
  )
}

#place(
  top + center,
  float: true,
  scope: "parent",
)[
  #set text(size: 21pt)
  Quineを書こう\
  〜自己を出力する不思議なプログラム〜

  #set text(size: 14pt)
  nsfisis（いまむら）
  #v(1em)
]

= はじめに〜Quineとは〜

== Quineの定義

Quine（クワイン）とは、自分自身のソースコードと一致する文字列を出力するようなプログラムのことです。PHPなら、

```terminal
$ php a.php > output.txt
```

と実行したとき、`output.txt`と`a.php`が完全に一致するような`a.php`を「Quine」と呼びます。一見すると不可能にすら思えますが、ほとんどの言語で簡単に書くことができます。

例として、PHPで書かれたQuineを一つ見てみましょう。

#file("simple.php")[
```php
<?eval($s='printf("<?eval(\$s=%c%s%c);\n",39,$s,39);');
```
]

※紙面の都合上改行が挟まっていますが、一行で入力してください。背景色が同じなら同じ行です。

これを実行すると、上記の文字列がそのまま出力されます。

```terminal
$ php simple.php
<?eval($s='printf("<?eval(\$s=%c%s%c);\n",39,$s,39);');
```

これがQuineの定義です。

なお、この記事に記載しているコードはすべてGitHubのリポジトリへアップロードしていますので、実行の際はそちらを用いることをお勧めします（記事末尾にURLとQRコードがあります）。

== 自明なQuine

さて、上記の定義を見た勘の良い方なら、こんなことに気付くかもしれません。「空のファイルでも条件を満たすのでは？」`main`関数を書かなければならない言語ならばいざ知らず、PHPのような言語なら空のソースコードは適格なプログラムです。これを「実行」すれば確かに空の出力が得られ、それは自己のソースコードと一致します。

更にPHPの場合、PHPタグの外に書かれたテキストはそのまま出力されるため、次のようなPHPコードも考えられます。

#file("illegal-quine.php")[
```php
Hello, PHPerKaigi!
```
]

これも`php`コマンドで実行すればソースコードと同じ出力が得られます。また、自身をファイルとして読み込む次のようなコードも考えられるかもしれません。

#file("illegal-quine2.php")[
```php
<?echo file_get_contents(__FILE__);
```
]

ただ、一般的に「Quine」と言ったときにこのようなコードは認めないことが多いようです（認めたとしても考察するほどの面白みはありませんが）。

= Quineを書いてみよう！

== Let's Try!

さあ、まずは何も考えずにQuineの作成に挑戦してみましょう。文字列を出力するプログラムですから、次のようになるはずです。

#file("try-quine.php")[
```php
<?php echo '...';
```
]

この`...`に`try-quine.php`の内容そのものを書くことができれば完成ですね！では書いてみましょう。

#file("try-quine2.php")[
```php
<?php echo '<?php echo \'...\';';
```
]

この`...`に`try-quine2.php`の内容そのものを書くことができれば完成ですね！では書いてみましょう。

#file("try-quine3.php")[
```php
<?php echo '<?php echo \'<?php echo \'<?php echo \\\'...\\\';\';\';';
```
]

この`...`に`try-quine3.php`の内容そのものを書くことができれば……いえ、そろそろ紙面がもったいないので止めておきましょう。

このアプローチでは、この調子で無限に置き換え作業を続けることになってしまいます。根本的な問題は、文字列の中でそれ自身を参照する必要があることです。一見すると無限の入れ子構造が必要に思えます。

== 解決のアイデア（その一）

これを解決する最初のアイデアは、変数を使った置き換えです。次の例を見てください。

#colbreak()

#file("try-quine4.php")[
```php
<?php $s = '<?php $s = \'...\'; echo strtr($s, [str_repeat(\'.\', 3) => $s]);'; echo strtr($s, [str_repeat('.', 3) => $s]);
```
]

`echo`で出力していた文字列を一度変数`$s`へと代入します。あとは、先ほどから繰り返していた「`...`に`try-quine4.php`の内容そのものを書く」を文字列置換によって実現します。`strtr()`を使って`$s`内の`...`を`$s`へと置き換えています。

ここで、`strtr($s, ['...' => $s])` とは書けないことに注意してください。もしこう書いてしまうと、その`...`もまた`$s`へと置き換えられてしまうからです。

これで上手くいくでしょうか。動かしてみましょう。

```terminal
$ php try-quine4.php
<?php $s = '<?php $s = '...'; echo strtr($s, [str_repeat('.', 3) => $s]);'; echo strtr($s, [str_repeat('.', 3) => $s]);
```

元のソースコードにとても似ていますが少しだけ違いがありますね。`$s`の中でエスケープしていた`\'`が単独の`'`に戻ってしまいました。元々のソースでエスケープされていた文字は、出力時にもエスケープしてやる必要があります。エスケープ処理を自分で実装してもいいのですが、PHPにはおあつらえ向きの関数`addslashes()`があります。これは、クォートやバックスラッシュ、NULバイトをエスケープしてくれる関数です。もちろんQuineを実装するために用意したに違いありません。今回はこれを使いましょう。

#file("try-quine5.php")[
```php
<?php $s = '<?php $s = \'...\'; echo strtr($s, [str_repeat(\'.\', 3) => addslashes($s)]);'; echo strtr($s, [str_repeat('.', 3) => addslashes($s)]);
```
]

これを実行してみます。

```terminal
$ php try-quine5.php
<?php $s = '<?php $s = \'...\'; echo strtr($s, [str_repeat(\'.\', 3) => addslashes($s)]);'; echo strtr($s, [str_repeat('.', 3) => addslashes($s)]);
```

元のソースコードと完全に一致する出力が得られました！これにてQuine完成です。なお、`diff`コマンドを使うともう少しスマートに確かめられます。

```terminal
$ php try-quine5.php > result
$ diff -s try-quine5.php result
Files try-quine5.php and result are identical
```

シェルによってはプロセス置換を使ってもいいですね。

```terminal
$ diff -s try-quine5.php <(php try-quine5.php)
```

Quineの基本構造は次のようになります。

+ ソースコード全体を表す変数を、自分自身を何らかのプレースホルダで置き換えた上で用意する
+ その変数のプレースホルダを、その変数の値で置換する
+ 結果を出力する

== 解決のアイデア（その二）

Quine自体は前述の方法で作れるようになりましたが、少々重複が多いのが気になるところです。もっと簡潔に書けないでしょうか？

実は`eval()`（動的な文字列をプログラムとしてその場で解釈し、実行する処理）を持つ言語では、より短くQuineを書けることがあります。PHPでも`eval()`を活用することでより簡潔なQuineを書くことができます。

先ほどの`try-quine5.php`において、`$s`中の`...`を`$s`自身で置き換えた文字列とは、`try-quine5.php`のソースコードそのものです。では、これをそのまま実行すれば`try-quine5.php`を実行したことになりますね？文字列をPHPコードとして実行する処理、つまり`eval()`の出番です。

#file("try-quine6.php")[
```php
<?php $s = 'echo strtr("<?php \$s = \'...\'; eval(\$s);", [str_repeat(\'.\', 3) => addcslashes($s, chr(39))]);'; eval($s);
```
]

このコードで`eval()`される文字列は以下のとおりです。

```php
echo strtr("<?php \$s = '...'; eval(\$s);", [str_repeat('.', 3) => addcslashes($s, chr(39))]);
```

これを見ると、

+ ソースコード全体を表す変数を、自分自身を何らかのプレースホルダで置き換えた上で用意する
+ その変数のプレースホルダを、その変数の値で置換する
+ 結果を出力する

というQuineの基本処理が実行されていることがわかります。`try-quine5.php`と比べ、`strtr()`関連の処理が一回しか書かれていないことがわかるでしょうか。

なお、`eval()`を使う場合、`addslashes()`によってダブルクォート等がエスケープされてしまうと有効なPHPコードではなくなってしまうので、シングルクォートだけをエスケープするよう`addcslashes()`を用いています。こちらはエスケープ対象の文字を指定することができ、`chr(39)`とは`'`のことです。

冒頭に掲載した`simple.php`は、この考え方で更に短くしたものです。置換処理自体は`printf()`の`%s`指定子でおこなっており、エスケープ対象であるシングルクォートの出力も`printf()`の`%c`指定子を使っています。


= 応用Quine

基本的なQuineの仕組みを理解すれば、より複雑で面白い挙動をするQuineを作ることができます。ここでは代表的な応用例を紹介します。

== Quineアスキーアート

Quineは本質的にはただの文字列の出力プログラムです。ソースコードを特定の形に整形することで、面白い見た目のQuineを作れます。

こちらをご覧ください。

#file("quine-japan.php")[
```php
<?eval(preg_replace("/\s/","",$s='
p                                r
i             ntf("              <
?            eval(pr             e
g           _replace(            \
"            /\s/\",             \
"             \",\$              s
=                                %
c%s%c));\n",047,$s,047,39,39);'));
```
]

日の丸の形をしたQuineです（比率その他には目をつぶってください）。これは`$s`の中にある空白や改行を、`eval()`へ渡す前に`preg_replace()`で取り除くことによって整形を実現しています。

この類のQuineは比較的簡単なテクニックで作ることができますが、その割に見た目に華があるので、Quine初心者が作ってみるのにお勧めです。

整形済みのソースコードを文字列として持っておいてそのままそれを出力する方式（このコードで採用しているもの）と、整形されていないソースコードを文字列として持っておいて出力の際に動的に整形処理をおこなう方式の二種類があります。

== 状態を持つQuine

Quineの定義上、通常は実行のたびに同じ出力を返しますが、実行ごとに出力が変化するQuineも作ることができます（厳密な意味でのQuineではありませんが、「変則Quine」といった呼び名でQuineの一種として扱われることが多いようです）。

これを実現するためには、ソースコードの一部に状態を持たせておき、置換処理をおこなう中で状態の更新をおこないます。単純な例を見てみましょう。

#file("countup-quine.php")[
```php
<?$n=0;eval($s='printf("<?\$n=%d;eval(\$s=%c%s%c);\n",$n+1,39,$s,39);');
```
]

このQuineは、実行のたびに`$n`の値が1ずつ増えていきます。

#colbreak()

これだけでは面白くないので、もう少し複雑な例を見てみましょう。こちらです。

#[
#show raw: set text(size: 6pt)
#file("quine-puzzle.php")[
```php
<?php $z='bcdefghia';eval($s=strtr('$M="array_map";$S="st
r_split";$C="chr";$zp=strpos($z,"a");[$dx,$dy]=match($arg
v[1               ]??               nul               l){
"h"               =>[               1,0               ],"
j"=         >[0   ,-1   ],"k"=>[0   ,1]   ,"l"=>[-1   ,0]
,de         fau   lt=   >[0,0],};   $zx   =$zp%3;$z   y=i
ntd         iv(   $zp         ,3)   ;$s         x=$   zx+
$dx         ;$s   y=$         zy+   $dy         ;if   ($s
x<0         ||2   <$s   x)$sx=$zx   ;if   ($sy<0||2   <$s
y)$         sy=   $zy   ;$sp=$sy*   3+$   sx;[$z[$s   p],
$z[         $zp   ]]=   [$z         [$z         p],   $z[
$sp         ]];   ech   o("         <?p         hp"   .$C
(32         ).$   C(3   6)."z=".$   C(3   9).$z.$C(   39)
.";         eva   l("   .$C(36)."   s=s   trtr(".$C   (39
));               $n=               $M(               $S,
$S(               "00               000               111
1141424414143341142414424344111143434",5));$m=$M($S,$S("0
00001100101111",3));$i=(new("ArrayObject")($S($s."//".$s,
)))               ->g               etI               ter
ato               r()               ;$B               =fn
($_   =1)   =>$   M(f   n()=>prin   t([   $i->curre   nt(
),$   i->   nex   t()   ][0]),ran   ge(   1,$_*3));   $W=
fn(   $_=   1)=   >pr   int         (st   r_r         epe
at(   $C(   32)   ,$_   *3)         );$   N=f         n()
=>p   rint($C(1   0))   ;$B(7);$N   ();   for($y=0;   $y<
3;$   y++){$B(1   9);   $N();$B()   ;$W   (5);$B();   $W(
5);         $B(   );$         W(5   );$   B()   ;$N   ();
$B(         );$   W(5         );$   B()   ;$W   (5)   ;$B
();         $W(   5);   $B();$N()   ;fo   r($l=0;$l   <10
;$l         ++)   {$B   ();for($x   =0;   $x<3;$x++   ){$
W(1               );$               M(f               n($
_)=               >$_               ?$B               ():
$W(),$m[$n[$M("ord",$S($z))[$y*3+$x]-97][intdiv($l,2)]]);
$W(1);$B();}$N();}$B();$W(5);$B();$W(5);$B();$W(5);$B();$
N()               ;$B               ();               $W(
5);               $B(               );$               W(5
);$   B();$W(5)   ;$B   ();$N();$   B(1               9);
$N(   );}$B(9);   ech   o($C(39).   ",[               $C(
32)         =>"   .$C   (34   ).$   C(3               4).
",$         C(1   0)=   >".   $C(   34)               .$C
(34         )."   ]))   ;");//$M=   "ar               ray
_ma         p";   $S=   "str_spli   t";               $C=
"ch         r";   $zp   =st   rpo   s($               z,"
a")         ;[$   dx,   $dy   ]=m   atc               h($
arg         v[1   ]??   null){"h"   =>[               1,0
],"         j"=   >[0   ,-1],"k"=   >[0               ,1]
,"l               "=>               [-1               ,0]
,de               fau               lt=               >[0
,0],};$zx=$zp%3;$zy=intdiv($zp,3);$sx=$zx+$dx;$sy=$zy+//$
M="array_map";$S="str_split',[chr(32)=>"",chr(10)=>""]));
```
]
]

このQuineはスライドパズルになっており、引数で渡す値によって出力が変化します。「8」を右に動かしたいなら`php quine-puzzle.php l`と、「6」を下に動かしたいなら`php quine-puzzle.php j`と実行すれば、次の盤面が新たなソースコードとして出力されます。そのソースコードももちろんパズルになっており、もう一度実行することで二手動かした状態の盤面が得られます。操作はVimの移動キーと対応しており、それぞれ`h`が左、`j`が下、`k`が上、`l`が右移動です。

= おわりに

今回紹介したのはQuineのほんの一端にすぎません。より深くQuineを知るには、末尾の参考文献にも挙げている『あなたの知らない超絶技巧プログラミングの世界』という書籍がお勧めです。本記事、特に「Quineを書いてみよう！」の章は、同書の第三章の説明を大いに参考にさせていただきました。

この記事でQuineに興味を持っていただけたなら、ぜひご自身だけのQuineを書いてみてはいかがでしょうか。

最後に、拙作のQuineをいくつか紹介します。

- https://github.com/nsfisis/9-puzzle-quine.php
  - PHP
  - 記事中に記載したスライドパズルQuine
- https://github.com/nsfisis/cohackpp
  - PHP
  - 友人の結婚祝いに贈ったQuine。実行すると「ご結婚おめでとうございます」と一文字ずつ表示される
- https://github.com/nsfisis/phperbiglt-2025
  - Python + PHP
  - 「巳」の形のPythonコードと「午」形のPHPコードが交互に切り替わるQuine
- https://github.com/nsfisis/twitter2x-quine
  - Ruby
  - TwitterのロゴとXのロゴが交互に切り替わるQuine
- https://github.com/nsfisis/pong-wars-quine.rb
  - Ruby
  - 一時期SNSで話題になった「Pong Wars」を実装したQuine
- https://github.com/nsfisis/trick-2025
  - Ruby
  - Rubyプログラムにルビを振って出力するQuine
  - TRICK 2025というコンテストで入賞した作品

また、本記事中に出てくるソースコードは下記のGitHubリポジトリに同じファイル名でアップロードしています。`src/`ディレクトリ以下を参照してください。また、`test.sh`を走らせることでQuineになっているかどうかのテストが可能です。

https://github.com/nsfisis/phperkaigi-2026-brochure-article

#align(center)[
  #qr-code("https://github.com/nsfisis/phperkaigi-2026-brochure-article", width: 30mm)
]

= 参考文献

- 遠藤侑介『あなたの知らない超絶技巧プログラミングの世界』技術評論社、2015年
  - https://gihyo.jp/book/2015/978-4-7741-7643-7


#[
#v(10em)
余白を埋めるQuine、ヨハクワイン
#show raw: set text(size: 5pt)
#file("blanquine.php")[
```php
                               <?eval(
                            preg_replace
                          ("/\s/" ,"",$s='
                        printf(      "<?eval
                      (\n%spr          eg_repl
                    ace\n%s              (\"/\s/
                  \"%s,\"                  \",\$s=
                %c%s%c)                      );\n",(
              $r="str                          _repeat
            ")($w=c                              hr(32),
          28),$r(                                  $w,26),
        $w,39,$  s,39);/*printf("<?eval(\n%spreg_re  place\n
      %s(\"/\    s/\"%s,\"\",\$s=%c%s%c));\n",($r="    str_rep
    eat")($      w=chr(32),28),$r($w,26),$w,39,$s,3      9);prin
                               tf("<?e
                               val(\n%
                               spreg_r
          eplace\n%s(\"/\s/\"%s,\"\",\$s=%c%s%c));\n",($r="
          str_repeat")($w=chr(32),28),$r($w,26),$w,39,$s,39
          );printf("<?eval(\n%spreg_replace\n%s(\"/\s/\"%s,
                               \"\",\$
                s=%c%s%        c));\n"        ,($r="s
               tr_repe         at")($w         =chr(32
              ),28),$          r($w,26          ),$w,39
             ,$s,39)    ;printf("<?eva           l(\n%sp
            reg_rep        lace\n%s(\"            /\s/\"%
           s,\"\",            \$s=%c%s             %c));\n
          ",($r="                str_r              epeat")



                              ($w=chr
                             (32),28
                            ),$r($w
                           ,26),$w
                          ,39,$s,
                         39);pri
                        ntf("<?
               eval(\n%spreg_replace\n%s(\"/\s/\"%s,\"
               \",\$s=%c%s%c));\n",($r="str_repeat")($
               w=chr(32),28),$r($w,26),$w,39,$s,39);pr
               intf("<?eval(\n%spreg_replace\n%s(\"/\s
               /\"%s,\                         "\",\$s
               =%c%s%c                         ));\n",
               ($r="st                         r_repea
               t")($w=                         chr(32)
               ,28),$r($w,26),$w,39,$s,39);printf("<?e
               val(\n%spreg_replace\n%s(\"/\s/\"%s,\"\
               ",\$s=%c%s%c));\n",($r="str_repeat")($w
               =chr(32),28),$r($w,26),$w,39,$s,39);pri
               ntf("<?                         eval(\n
               %spreg_                         replace
               \n%s(\"                         /\s/\"%
               s,\"\",                         \$s=%c%
               s%c));\n",($r="str_repeat")($w=chr(32),
               28),$r($w,26),$w,39,$s,39);printf("<?ev
               al(\n%spreg_replace\n%s(\"/\s/\"%s,\"\"
               ,\$s=%c%s%c));\n",($r="str_repeat*/'));
```
]
]
