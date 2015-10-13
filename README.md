# Spud

Spud does terrible, horrible things to Trello lists.

Basically, I really like Trello. But I want to be able to formalize the workflow
I've been using for a while on my personal board, namely a modified version of
[Mark Forster's Final Version system](http://markforster.squarespace.com/final-version-faqs/).

In short: I've got a big list of tasks (mine's called, aptly enough, "Tasks".) I
go through two modes:

- **Selection:** I choose the very top card on the list by assigning myself to
  it, and then work down the list assigning myself things I want to do before
  the "root" task.

- **Work:** I filter the cards to just the ones I selected and work through them
  in the reverse order. As I go, if I'm "done" with a task I'll move it to the
  "done" category, and if I'm not done yet I'll add a note about what I did and
  move the card to the end of the list (and unassign myself, so I can't see it
  during the work time.)

  If I hit a block, I set a date on the card and put it into another list
  (called "Waiting / Follow Up / Later"). When that date comes, it gets put back
  at the end of the list so I can work on it.

## Implementation

I'm going to write this all in [Elm](http://elm-lang.org), because it looks
awesome and I'd like to try it out on a non-toy project.

Current status: just about done pulling down boards, lists, and cards from
Trello so I can write the business logic. Hooray!
