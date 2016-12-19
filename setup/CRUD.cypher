--create user node
CREATE (n:user { name: 'Emily Hua', email: "huaye1994@gmail.com" })
RETURN n
CREATE (n:user { name: 'Ivy Chen', email: "ivychen@gmail.com" })
RETURN n
CREATE (n:user { name: 'Vivan Peng', email: "vivianpeng@gmail.com" })
RETURN n
CREATE (n:user { name: 'Guanlin Zhou', email: "guanlinzhou@gmail.com" })
RETURN n

CREATE (n:user { name: 'Min Zhou', email: "minzhou@gmail.com" })
RETURN n
--create friendship among nodes (directed)
MATCH (a:user),( b:user)
WHERE a.name = 'Emily Hua' AND b.name = 'Ivy Chen'
CREATE (a)-[r:FRIEND]->(b)
return r
MATCH (a:user),( b:user)
WHERE a.name = 'Emily Hua' AND b.name = 'Vivan Peng'
CREATE (a)-[r:FRIEND]->(b)
return r

MATCH (a:user),( b:user)
WHERE a.name = 'Ivy Chen' AND b.name = 'Guanlin Zhou'
CREATE (a)-[r:FRIEND]->(b)
return r

MATCH (a:user),( b:user)
WHERE a.name = 'Vivan Peng' AND b.name = 'Min Zhou'
CREATE (a)-[r:FRIEND]->(b)
return r

--create comment node
CREATE (c:comment { id: 2, comment: "full of wit and menace" })
RETURN c
CREATE (c:comment { id: 1, comment: "Steven Moffat promised us a season opener that feels like a finale and, boy, does he deliver. In fact he delivers boy. Boy Davros. A brilliant idea – just waiting for someone to have it" })
RETURN c

--create episode node
CREATE (e:content { id: 1, name: "episode 1-The Magician's Apprentice" })
RETURN e

--create relationship among user comment (a commented b)
MATCH (a:user),( b:comment)
WHERE a.name = 'Ivy Chen' AND b.id = 2
CREATE (a)-[r:COMMENTED]->(b)
return r

--create relationship among user comment (a commented b)
MATCH (a:user),( b:comment)
WHERE a.name = 'Ivy Chen' AND b.id = 2
CREATE (a)-[r:COMMENTED]->(b)
return r

MATCH (a:user),( b:comment)
WHERE a.name = 'Emily Hua' AND b.id = 1
CREATE (a)-[r:COMMENTED]->(b)
return r

--create relationship among comment and content (a commentedUpon b)
MATCH (a:comment),( b:content)
WHERE a.id = 1 AND b.id = 1
CREATE (a)-[r:commentedUpon]->(b)
return r

MATCH (a:comment),( b:content)
WHERE a.id = 2 AND b.id = 1
CREATE (a)-[r:commentedUpon]->(b)
return r

--create follower relationship (a follows b)
MATCH (a:user),( b:user)
WHERE a.name = 'Ivy Chen' AND b.name = 'Guanlin Zhou'
CREATE (a)-[r:FOLLOW]->(b)
return r

--create like comment relationship
MATCH (a:user),( b:comment)
WHERE a.name = 'Guanlin Zhou' AND b.id = 1
CREATE (a)-[r:LIKE]->(b)
return r

--create people like content relationship 
MATCH (a:user),( b:content)
WHERE a.name = 'Min Zhou' AND b.id = 1
CREATE (a)-[r:LIKE]->(b)
return r

--create people rate content 
MATCH (a:user),( b:content)
WHERE a.name = 'Min Zhou' AND b.id = 1
CREATE (a)-[r:RATE {score : 5}]->(b)
return r

MATCH (a:user),( b:content)
WHERE a.name = 'Ivy Chen' AND b.id = 1
CREATE (a)-[r:RATE {score : 4}]->(b)
return r

MATCH (a:user),( b:content)
WHERE a.name = 'Vivan Peng' AND b.id = 1
CREATE (a)-[r:RATE {score : 3}]->(b)
return r

--update episode node
MATCH (a:content)
WHERE a.id = 1
SET a.name = "episode 1-The Magician's Apprentice"
--delete relationship

START n = node(*) 
MATCH (n)-[r: LIKECOMMENT]-> (b)
WHERE n.email='guanlinzhou@gmail.com' AND b.id = 1
DELETE r

--delete a node

MATCH (n { name: '5'})
DETACH DELETE n
