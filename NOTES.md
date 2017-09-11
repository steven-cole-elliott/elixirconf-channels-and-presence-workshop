# Phoenix Channels & Presence
*Instructor: Chris McCord*

- use `Phoenix.Token` for stuff like password reset links to be able to embed the expiration date in the token itself
- use `assigns[:key]` in html where that key may or may not be present, since it will err with `@key`
- `socket.connect()` will run as soon as it can
- be weary of relying heavily on longpolling, as it could be taken out some day...
- setting the `:max_age` for a socket verification is going to required in Phoenix 2.0
- use `IO.puts(">>....")` to send stuff to the iEx console
- should be able to assign key value pairs in the socket for preserving state as we would in the conn in controllers -> this should be what we implement for wizardry
- every client that joins a channel has his own process on the server
- should consider handling errors and timeouts from channel responses in our javascript so that we can relay that information in the UI to the user
- for our wizardry stuff that is actually using controller actions but doesn't submit until the end, we could spawn a long running process and store the pid of that process in the session, and then store the state of the wizardry steps in that long running process's state, updating it each time we come back from the client using the pid, which Elixir will find across node clusters without any extra code/effort from us -> we would use the following code to create the pid that we would store in the session and then use to retrieve the state of the wizardry from the long running process:
```
  iex> :erlang.term_to_binary(self()) |> Base.encode64
  "g2dkAA1ub25vZGVAbm9ob3N0AAAA8AAAAAAA"
```
- for wizardry stuff that is using channels, that state can just be stored in the socket and sent back and forth in the assigns between the client and the server
- Phoenix does have helpers for channel testing!
- Presence is always scoped to a single topic
