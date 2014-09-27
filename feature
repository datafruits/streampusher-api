FIRST FEATURES
----------------
* hosted icecast/liquidsoap
* stats
  * realtime listener count
  * listeners per day?

* auto dj
  * upload mp3s
  * create playlist

* dj scheduling

* browser based broadcast
* easy to use embeddable widgets
  * player
  * stats
  * schedule/calendar

--------------
User
  has_one :subscription

Subscription

Plan

RadioServer
  belongs_to :user
  belongs_to :subscription

  status: booting, running, stopped

  boot, stop, restart

  port
    persist port to haproxy?

Stream
  belongs_to :radio_server
  has_many :listens
  url

services
--------
  NewRadioServer
    * boot via docker
      probably a sidekiq job?

user sign up, choose plan, create radio server
