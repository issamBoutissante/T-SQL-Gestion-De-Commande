create database GestionCom
use GestionCom

--1-	Proc�der � la cr�ation de la base de donn�es GestionCom
create table Article(
numArt int,
desArt varchar(15),
puart decimal,
qtEenStock int,
seuilMinimum int,
seuilMaximum int,
constraint pk_article primary key(numArt)
)
insert into Article values(1,'pc',10000,3,2,10)
insert into Article values(2,'usb',100,22,5,100)
insert into Article values(3,'mouse',600,7,1,10)
create table Commande(
numCom int,
dateCom date,
constraint pk_commande primary key(numCom)
)
insert into Commande values(1,GETDATE())
insert into Commande values(2,GETDATE())
insert into Commande values(3,GETDATE())
insert into Commande values(4,GETDATE())
insert into Commande values(5,GETDATE())
insert into Commande values(6,GETDATE())
insert into Commande values(7,GETDATE())
insert into Commande values(8,GETDATE())
insert into Commande values(9,GETDATE())
insert into Commande values(10,GETDATE())
insert into Commande values(11,GETDATE())

create table LigneCommande(
numCom int,
numArt int,
qteCommandee int,
constraint fk_ligneC_commande foreign key(numCom) references Commande(numCom),
constraint fk_ligneC_article foreign key(numArt) references Article(numArt),
constraint pk_ligneCommande primary key(numCom,numArt)
)
insert into LigneCommande values(1,2,10)
insert into LigneCommande values(3,2,10)
insert into LigneCommande values(10,1,10)
insert into LigneCommande values(10,2,100)
insert into LigneCommande values(10,3,100)
insert into LigneCommande values(3,1,100)
insert into LigneCommande values(7,1,100)
insert into LigneCommande values(8,1,100)


-- 2- Ecrire un programme qui calcule le montant de la commande num�ro 10 et 
-- affiche un message 'Commande Normale' ou 'Commande Sp�ciale' selon que le montant
-- est inf�rieur ou sup�rieur � 100000 DH 

declare @montant decimal;
select @montant=sum(qteCommandee*puart)
from LigneCommande join Article 
on LigneCommande.numArt=Article.numArt
where numCom=10
if @montant<=100000
   print 'Commande Normale'
else 
   print 'Commande Sp�ciale'




-- 3-	Ecrire un programme qui
-- supprime l'article num�ro 3 de la commande
-- num�ro 5 et met � jour le stock. Si apr�s la
-- suppression de cet article, la commande num�ro5 
-- n'a plus d'articles associ�s, la supprimer.

--la supprission d'article
-- avant de supprimer il faut sauvegarder le stock de la ligne
declare @qtCommandee int;
select @qtCommandee=qteCommandee from LigneCommande 
where numArt=3 and numCom=5
delete from LigneCommande 
where numArt=3 and numCom=5
-- la mise a jour de stock
declare @qtenstock int;
select @qtenstock=qtEenStock from Article
where numArt=3;

update Article set qtEenStock=@qtenstock+1
where numArt=3

-- si la commande num�ro 5 
-- n'a plus d'articles associ�s 
-- on va la supprimer
declare @nArticle int;
select @nArticle=count(numCom)from LigneCommande
where numCom=5
if @nArticle=0
  delete from Commande where numCom=5
  
-- 4-	Ecrire un programme qui affiche la liste des commandes et indique pour 
-- chaque commande dans une colonne Type s'il s'agit d'une commande normale 
-- (montant <=100000 DH) ou d'une commande sp�ciale (montant > 100000 DH) 

select numCom,'Type'=
Case
  when sum(qteCommandee*puart)<=100000 then 'normale'
  when sum(qteCommandee*puart)>100000 then 'speciale'
end
from LigneCommande join Article 
on LigneCommande.numArt=Article.numArt
group by numCom

-- 5-	A supposer que toutes les commandes ont des montants diff�rents, 
-- �crire un programme qui stocke dans une nouvelle table temporaire les 5 
-- meilleures commandes (ayant le montant le plus �lev�) class�es par montant d�croissant 
-- (la table � cr�er aura la structure suivante : NumCom, DatCom, MontantCom) 
declare @temTable table(
numCom int,
dateCom date,
montantCom decimal
)
insert into @temTable 
select top 5 commande.numCom,dateCom,sum(qteCommandee*puart) from LigneCommande join Article
on LigneCommande.numArt=Article.numArt join Commande on Commande.numCom=LigneCommande.numCom
group by commande.numCom,dateCom
select * from @temTable
order by montantCom desc

-- 6-	Ecrire un programme qui : 
--       -  Recherche le num�ro de commande le plus �lev� dans la table commande et l'incr�mente de 1 
--       -  Enregistre une commande avec ce num�ro 
--       -  Pour chaque article dont la quantit� en stock est inf�rieure ou �gale au seuil minimum  
--          enregistre une ligne de commande avec le num�ro calcul� et une quantit� command�e 
--          �gale au triple du seuil minimum 


declare @numEleve int;
select @numEleve =max(numCom)+1 from commande
insert into Commande values(@numEleve,GETDATE())
declare @articleLen int;
select @articleLen=count(*) from Article
declare @i int=1
while @i<=@articleLen
   begin
      
   end