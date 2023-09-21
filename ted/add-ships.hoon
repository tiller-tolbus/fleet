/-  spider, *fleet
/+  strandio
^-  thread:spider
|=  arg=vase
=+  !<([~ ships=(list ship)] arg)
=/  m  (strand:rand ,vase)
|-  ^-  form:m
?~  ships  (pure:m !>([%fleet %add-ships %done]))
;<  ~  bind:m  (poke-our:strandio %fleet fleet-command+!>([%add-ship i.ships]))
$(ships t.ships)
