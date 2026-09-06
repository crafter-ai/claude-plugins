---
name: brand-name-creator
description: >
  Creates brand names for apps, products, startups, companies and features using the
  Lexicon Branding method of David Placek (Vercel, Azure, Sonos, BlackBerry, Windsurf): a
  Diamond Exercise to set direction, outside-category word hunting, high-volume generation
  with sound symbolism, processing fluency and compound names, then a shortlist stress-tested
  with the "new competitor" test. Runs the marketing:domain-availability-checker agent when
  the user will register a domain (.com and .app, plus .com.br for Brazil-focused products).
  Use whenever the user asks for a name for their app, product, startup, company, feature or
  project, brand name ideas, naming help, a rename, "come up with a name", "what should I
  call it", or in Portuguese "nome para meu app/startup/produto/empresa", "nome de marca",
  "ideias de nome", "como chamar", "renomear", "naming".
---

# brand-name-creator

Names a product the way Lexicon Branding does: strategy first, then volume with judgment
suspended, then a shortlist that starts a story instead of describing the product. Follow
the steps in order. Read `techniques.md` in this skill's directory before step 4.

Arguments, if any, describe the product: $ARGUMENTS

## Ground rules

- Descriptive names (Cloud Pro, Codium) blend into the category. Every shortlist entry must
  start a story.
- Never evaluate while generating. When reviewing, speculate instead of judging.
- Comfort is a warning sign: "If your team is comfortable with a name, chances are you
  don't have the name yet."
- A domain is an area code, not a veto.

## Step 1: Diamond Exercise

Draft the four points from what the user has said, show the draft, and ask them to correct
it in one round. If you know nothing about the product yet, ask first what it does and what
flow or feeling users should have.

- WIN (top): what winning means for this product.
- HAVE (right): assets, skills and features already in hand that make it a winner.
- NEED (bottom): the gaps to fill: resources, distribution, a compelling story.
- SAY (left): the message that makes the target audience lean in. This is the bridge into
  the customer's behavior and emotional experience.

Settle two facts in the same message if they are not evident: the market (global/US or
mostly Brazil) and whether the user will register a domain.

## Step 2: Behavior and experience

Skip missions, values and positioning statements. Answer three questions in one line each:
How do we want to behave in the market? How do we want the market to behave toward us? What
experience are we creating? Google won as a lightweight, delightful search experience
against practical, descriptive competitors like Infoseek.

## Step 3: Step outside the category

Names brainstormed inside the niche come out descriptive and copycat. Pick five worlds
unrelated to the product's category (sailing, aviation, hunting, mountaineering, cooking,
music, geology, astronomy, textiles, surfing, racing, gardening, cartography). For each,
list 50 words and expressions with texture: motion, tools, gestures, sounds, weather.
Create `brand-name-candidates.md` in the working directory and put these lists at the top
under "Source words". Nothing from the product's own category goes in.

## Step 4: Volume, judgment suspended

Target 1,000 names in the file; never stop under 500. Stopping at 200 because nothing feels
right is the common failure. Work in batches of about 100, one direction per batch, each
appended as its own section:

1. Compounds: product-feeling word + outside-world word (Windsurf, Powerbook).
2. Coined words from familiar roots (Vercel = ver + cel).
3. Letter-seeded sets: V, B, Z, X first, then letters whose energy fits step 2.
4. Tangible metaphors: movement, flow, sport, physical tools.
5. Structural play: palindromes, mirrors, rhythm.
6. Borrowed and respelled words, with Portuguese roots when the market is Brazil.
7. Short coinages of one or two syllables.
8. Wild cards: names that would make the team uncomfortable.

Do not dedupe, rank or comment while generating. After the last batch, read the file back
and speculate on the promising ones: "What could we do with this? What is the story? How
would we execute it?"

## Step 5: Shortlist and polarization

Pick 20 to 30 names spanning the directions. For each: pronunciation (and whether it
survives both Portuguese and English mouths when relevant), the story it starts in one
line, the letter energy, and why it might polarize. List safe, descriptive names in a
separate group under a warning that they are probably not the name. Pentium and Sonos were
rejected internally before they won; a name that splits the team has creative energy.

## Step 6: New competitor test

For the top 10, simulate the test: "Our biggest competitor just launched a new app called
[Name]. What do you think they are up to?" Write the one-line answer a stranger would give;
that is the name's narrative power. Then give the user that script word for word to run
with three to five people outside the team, and tell them never to ask "What do you think
of this name?"

## Step 7: Domain as an area code

Only when the user will register a domain (step 1). Launch the
`marketing:domain-availability-checker` agent with the shortlist names and the TLDs:
`com,app` for global or US products, `com,app,com.br` for mostly-Brazil products (.com and
.app work in Brazil too). Add the results as columns of the shortlist table. A taken .com
does not kill a name: for the top three whose .com is taken, have the agent also check
prefix and suffix variants (get-, try-, use-, -app, -hq, -labs) and the .ai. If the user
said nothing about a domain, skip this step and offer it in one line at the end.

## Deliver

Final message: the shortlist table (name, direction, story, polarization, and domain
columns when checked), the path of the candidates file, the competitor-test script, and the
next step: run the test with real people and look for the name that splits the room. This
skill does not check trademarks; tell the user to search the USPTO (US), INPI (Brazil) or
EUIPO before committing.
