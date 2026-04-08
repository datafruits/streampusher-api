##
# MetadataChannel - ActionCable channel for real-time now-playing metadata updates.
#
# Replaces the Ember `metadata` service which received WebSocket metadata updates
# from the Icecast/Liquidsoap stream. This channel broadcasts metadata to all
# connected clients via Turbo Streams, updating the player title in real-time.
#
# The datafruits-player Web Component listens for "metadataUpdate" DOM events
# which are dispatched by Turbo Stream broadcasts to this channel.
#
class MetadataChannel < ApplicationCable::Channel
  def subscribed
    stream_from "metadata_channel"
  end

  def unsubscribed
    stop_all_streams
  end
end
