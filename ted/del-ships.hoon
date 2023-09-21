/-  spider, *fleet
/+  strandio
^-  thread:spider
|=  arg=vase
=+  !<([~ ships=(list ship)] arg)
=/  m  (strand:rand ,vase)
|-  ^-  form:m
?~  ships  (pure:m !>([%fleet %del-ships %done]))
;<  ~  bind:m  (poke-our:strandio %fleet fleet-command+!>([%del-ship i.ships]))
$(ships t.ships)
