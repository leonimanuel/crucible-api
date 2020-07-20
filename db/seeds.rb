
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
billy = User.create(name: "Billy", email: "billy@aol.com", password: "greenbeans")
claire = User.create(name: "Claire", email: "claire@gmail.com", password: "fishsticks")
ashley = User.create(name: "Ashley", email: "ashley@yahoo.com", password: "milkmaid")
megan = User.create(name: "Megan", email: "megan@aol.com", password: "greenbeans")
ben = User.create(name: "Ben", email: "ben@gmail.com", password: "fishsticks")
luke = User.create(name: "Luke", email: "luke@yahoo.com", password: "milkmaid")
 
fact1 = Fact.create(content: "pandas are big", url: "pandas.com")
fact2 = Fact.create(content: "shrimp are small", url: "shrimp.com")
fact5 = Fact.create(content: "Employment in science, technology, engineering and math (STEM) occupations has grown 79% since 1990, from 9.7 million to 17.3 million, outpacing overall U.S. job growth", url: "https://www.pewresearch.org/fact-tank/2018/01/09/7-facts-about-the-stem-workforce/")

fact3 = Fact.create(content: "science is cool", url: "science.com")
fact4 = Fact.create(content: "science is hard", url: "science.com")


new_facts = Topic.create(name: "New Facts", user: billy)
new_facts_2 = Topic.create(name: "New Facts", user: megan)
edu = Topic.create(name: "Education", user: megan)
science = Topic.create(name: "Science", user: billy)
zoo = Topic.create(name: "Zoology", user: billy, parent: science)
politics = Topic.create(name: "Politics", user: billy)
civil_rights = Topic.create(name: "Civil Rights", user: billy, parent: politics)
climate_change = Topic.create(name: "Climate Change", user: billy, parent: politics)
blm = Topic.create(name: "Black Lives Matter", user: billy, parent: civil_rights)
free_speech = Topic.create(name: "Free Speech", user: billy, parent: civil_rights)
fifth_amendment = Topic.create(name: "Fith Amendment", user: billy, parent: free_speech)

zoo.facts << fact1
zoo.facts << fact2
new_facts.facts << fact3
new_facts.facts << fact4
edu.facts << fact5

fam = Group.create(name: "The Fam")
econ = Group.create(name: "Econ 100")
fam.users.push(billy, megan, ashley)


# new_drug = Discussion.create(name: "This New Drug is Lit", group: fam)


