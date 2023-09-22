::  %fleet: fleet monitoring
::
/-  *fleet
/+  default-agent, dbug, rudder
/~  pages  (page:rudder records command)  /app/fleet/webui
=>
  |%
  +$  card  $+(card card:agent:gall)
  +$  state-0  [%0 records]
  --
=|  state-0
=*  state  -
%-  agent:dbug
^-  agent:gall
=<
  |_  =bowl:gall
  +*  this  .
      def   ~(. (default-agent this %|) bowl)
      cor   ~(. +> bowl)
  ++  on-init
    ^-  (quip card _this)
    :_  this
    :-  (set-timer:cor ~s0)
    [%pass /eyre %arvo %e %connect `/[dap.bowl] dap.bowl]~
  ::
  ++  on-save  !>(state)
  ++  on-load  |=(=vase `this(state !<(state-0 vase)))
  ++  on-poke
    |=  [=mark =vase]
    ^-  (quip card _this)
    ?+    mark  (on-poke:def mark vase)
    ::
        %fleet-command
      ?>  =(our src):bowl
      =+  !<(cmd=command vase)
      ?-  -.cmd
        %add-steward  `this(stewards (~(put in stewards) ship.cmd))
        %del-steward  `this(stewards (~(del in stewards) ship.cmd))
        %add-ship     `this(fleet (~(put in fleet) ship.cmd))
        %del-ship     `this(fleet (~(del in fleet) ship.cmd))
        %set-send-alerts  `this(send-alerts flag.cmd)
        %set-default-heartbeat  `this(default-heartbeat t.cmd)
      ::
          %set-heartbeat
        `this(heartbeats (~(put by heartbeats) ship.cmd t.cmd))
      ::
          %set-run-interval
        =.  run-interval  t.cmd
        :_  this
        [(set-timer:cor run-interval) cancel-timers:cor]
      ::
          %set-max-log-size
        =^  cards  state
          abet:(set-max-log-size:cor size.cmd)
        [cards this]
      ::
          %set-kids-update
        ?.  (gte t.cmd run-interval)
          %-  (slog '%kids-update must be >= %run-interval' ~)
          [~ this]
        `this(kids-update t.cmd)
      ==
    ::
        %handle-http-request
      ?>  =(our src):bowl
      =;  out=(quip card _+.state)
        [-.out this(+.state +.out)]
      %.  [bowl !<(order:rudder vase) +.state]
      %-  (steer:rudder _+.state command)
      :^    pages
          (point:rudder /[dap.bowl] & ~(key by pages))
        (fours:rudder +.state)
      |=  cmd=command
      ^-  $@  brief:rudder
          [brief:rudder (list card) _+.state]
      =^  cards  this
        (on-poke %fleet-command !>(`command`cmd))
      ['Processed succesfully.' cards +.state]
    ==
  ::
  ++  on-leave  on-leave:def
  ++  on-watch
    |=  =path
    ^-  (quip card _this)
    ?>  =(our src):bowl
    ?+  path  (on-watch:def path)
      [%http-response *]  `this
    ==
  ::
  ++  on-arvo
    |=  [=wire =sign-arvo]
    ^-  (quip card _this)
    ?+  wire  (on-arvo:def wire sign-arvo)
      [%eyre ~]  `this
    ::
        [%interval ~]
      ?>  ?=([%behn %wake *] sign-arvo)
      ?^  error.sign-arvo
        %-  (slog '%fleet %timer-error' u.error.sign-arvo)
        [(set-timer:cor run-interval)^~ this]
      =^  cards  state  abet:on-interval:cor
      [cards this]
    ==
  ::
  ++  on-peek
    |=  =path
    ^-  (unit (unit cage))
    ?+  path  (on-peek:def path)
      [%x %logs ~]               ``noun+!>(logs)
      [%x %fleet ~]              ``noun+!>(fleet)
      [%x %downed ~]             ``noun+!>(downed)
      [%x %stewards ~]           ``noun+!>(stewards)
      [%x %heartbeats ~]         ``noun+!>(heartbeats)
      [%x %kids-update ~]        ``noun+!>(kids-update)
      [%x %send-alerts ~]        ``noun+!>(send-alerts)
      [%x %run-interval ~]       ``noun+!>(run-interval)
      [%x %last-kids-update ~]   ``noun+!>(last-kids-update)
      [%x %default-heartbeat ~]  ``noun+!>(default-heartbeat)
    ==
  ::
  ++  on-agent  on-agent:def
  ++  on-fail   on-fail:def
  --
=|  cards=(list card)
|_  =bowl:gall
+*  cor   .
++  abet  [(flop cards) state]
++  emit  |=(=card cor(cards [card cards]))
++  emil  |=(caz=(list card) cor(cards (welp (flop caz) cards)))
++  set-timer  |=(t=@dr [%pass /interval %arvo %b %wait (add t now.bowl)])
++  update-kids
  |=  spon=ship
  |^  ^+  state
      =/  next-update=@da
        `@da`(add last-kids-update `@dr`(sub kids-update run-interval))
      =/  update-required=?  (gte now.bowl next-update)
      ?.  update-required
        state
      =/  old=(set ship)  fleet
      =.  fleet  (sponsored-ships spon)
      =.  last-kids-update  now.bowl
      state
  ++  del-ships
    |=  ships=(list ship)
    |-  ^+  state
    ?~  ships
      state
    =.  fleet       (~(del in fleet) i.ships)
    =.  downed      (~(del by downed) i.ships)
    =.  heartbeats  (~(del by heartbeats) i.ships)
    $(ships t.ships)
  ++  sponsored-ships
    |=  spon=ship
    |^  ^-  (set ship)
        %-  silt
        %+  murn  ~(tap in peers)
        |=  =ship
        ?.  =(spon (sein:title our.bowl now.bowl ship))
          ~
        `ship
    ++  peers
      ^-  (set ship)
      =+  [our=(scot %p our.bowl) now=(scot %da now.bowl)]
      %~  key  by
      .^((map ship ?(%alien %known)) %ax /[our]//[now]/peers)
    --
  --
::
++  cancel-timers
  ^-  (list card)
  =+  [our=(scot %p our.bowl) now=(scot %da now.bowl)]
  %+  murn
    .^((list [@da duct]) %bx /[our]//[now]/debug/timers)
  |=  [t=@da =duct]
  ?~  duct  ~
  ?.  ?=([%gall %use %fleet @ @ @ ~] i.duct)
    ~
  `[%pass t.t.t.t.t.i.duct %arvo %b %rest t]
::
++  on-interval
  |^  ^+  cor
      =.  cor  (emit (set-timer run-interval))
      =.  state  (update-kids our.bowl)
      =/  ships=(list ship)  ~(tap in fleet)
      |-  ^+  cor
      ?~  ships
        cor
      =/  last=(unit @da)  (last-contact i.ships)
      =/  down=?  (is-down i.ships last)
      ::  revived
      =?  cor  &(!down (~(has by downed) i.ships))
        (handle-revived i.ships)
      ::  downed
      =?  cor  &(down !(~(has by downed) i.ships))
        (handle-downed i.ships last)
      =?  cor  !(pumping i.ships)
        (send-ping i.ships)
      $(ships t.ships)
  ::
  ++  handle-downed
    |=  [=ship last=(unit @da)]
    ^+  cor
    =.  downed  (~(put by downed) ship last)
    =/  msg=cord  %-  crip
      =/  time=tape  ?~(last "unknown" <`@dr`(sub now.bowl u.last)>)
      "{<ship>} has not been contacted by {<our.bowl>} in {time}."
    (send-talk ship msg)
  ::
  ++  handle-revived
    |=  =ship
    ^+  cor
    =/  old=(unit @da)  (~(got by downed) ship)
    =.  downed          (~(del by downed) ship)
    =/  msg=cord  %-  crip
      =/  time=tape  ?~(old "unknown" <`@dr`(sub now.bowl u.old)>)
      "{<ship>} has contacted {<our.bowl>}. Downtime: {time}"
    (send-talk ship msg)
  ::
  ++  is-down
    |=  [=ship last=(unit @da)]
    ^-  ?
    ?:  =(ship our.bowl)
      %|
    ?~  last
      %&
    =/  threshold=@dr  (~(gut by heartbeats) ship default-heartbeat)
    (gte `@dr`(sub now.bowl u.last) threshold)
  ::
  ++  last-contact
    |=  =ship
    ^-  (unit @da)
    =+  [our=(scot %p our.bowl) now=(scot %da now.bowl) who=(scot %p ship)]
    .^((unit @da) %ax /[our]//[now]/peers/[who]/last-contact)
  ++  pumping
    |=  =ship
    ^-  ?
    ?.  (~(has in peers) ship)
      %|
    =+  [our=(scot %p our.bowl) now=(scot %da now.bowl) ship=(scot %p ship)]
    =+  .^(=ship-state:ames %ax /[our]//[now]/peers/[ship])
    ?:  ?=([%known *] ship-state)
      %-  ~(any by snd.ship-state)
      |=  m=message-pump-state:ames
      !=(~ next-wake.packet-pump-state.m)
    ?>  ?=([%alien *] ship-state)
    ?~(messages.ship-state %| %&)
  ::
  ++  peers  ~+
    ^-  (set ship)
    =+  [our=(scot %p our.bowl) now=(scot %da now.bowl)]
    %~  key  by
    .^((map ship ?(%alien %known)) %ax /[our]//[now]/peers)
  ++  send-ping
    |=  =ship
    ^+  cor
    ?:  =(ship our.bowl)  cor
    %-  emit
    [%pass /ping/(scot %da now.bowl) %agent [ship %ping] %poke noun+!>(~)]
  --
::
++  log-orm  ((on @da log-entry) gth)
++  set-max-log-size
  |=  size=@ud
  ^+  cor
  =.  max-log-size  size
  trim-logs
::
++  trim-logs
  ^+  cor
  ?.  (gth (lent (tap:log-orm logs)) max-log-size)
    cor
  =/  key=(unit @da)  `key:(snag max-log-size (tap:log-orm logs))
  cor(logs (lot:log-orm logs ~ key))
::
++  send-talk
  |=  [kid=ship msg=cord]
  |^  ^+  cor
      =.  cor  (add-to-log kid msg)
      ?.  send-alerts
        cor
      %-  emil
      %+  turn  ~(tap in stewards)
      |=  =ship
      =/  action  :*
        ship
        [ship now.bowl]
        %add
        ~
        our.bowl
        now.bowl
        [%story `~[msg]]
      ==
      [%pass /chat %agent [our.bowl %chat] %poke %dm-action !>(action)]
  ::
  ::
  ++  add-to-log
    |=  [kid=ship msg=cord]
    |^  ^+  cor
        =/  key=@da  (unique-time now.bowl)
        =/  recipients=(set ship)  ?:(send-alerts stewards ~)
        =/  =log-entry  [now.bowl recipients kid msg]
        =.  logs  (put:log-orm logs key log-entry)
        trim-logs
    ++  unique-time
      |=  now=@da
      |-  ^-  @da
      ?.  (has:log-orm logs now)
        now
      $(now `@da`(add now (div ~s1 1.000)))
    --
  --
--
