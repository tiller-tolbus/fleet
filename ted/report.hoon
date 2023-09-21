/-  spider, *fleet
/+  strandio
^-  thread:spider
|=  arg=vase
=/  m  (strand:rand ,vase)
^-  form:m
;<  our=@p  bind:m  get-our:strandio
;<  now=@da  bind:m  get-time:strandio
;<  =fleet  bind:m  (scry:strandio fleet /gx/fleet/fleet/noun)
;<  =downed  bind:m  (scry:strandio downed /gx/fleet/downed/noun)
=/  downed=json
%-  pairs:enjs:format
%+  turn  ~(tap by downed)
|=  [=ship t=(unit @da)]
^-  [@t json]
:-  (scot %p ship)
?~  t  ~
(time:enjs:format u.t)
=/  fleeta=json  [%a (turn ~(tap in fleet) ship:enjs:format)]
(pure:m !>((en:json:html [%a ~[fleeta downed]])))