-- =========================
-- INFORMATION DES UTILISATEURS
-- =========================

CREATE TABLE Role (
    Id INTEGER PRIMARY KEY,
    NomRole VARCHAR(30),
    DescriptionRole VARCHAR(50)
);

CREATE TABLE Permission (
    Id INTEGER PRIMARY KEY,
    NomPermission VARCHAR(30),
    DescriptionPermission VARCHAR(50)
);

CREATE TABLE RolePermission (
    Id INTEGER PRIMARY KEY,
    IdRole INTEGER,
    IdPermission INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdPermission) REFERENCES Permission(Id)
);

CREATE TABLE Utilisateur (
    Id INTEGER PRIMARY KEY,
    Email VARCHAR(30),
    MotDePasse VARCHAR(8),
    EtatUtilisateur VARCHAR(50),
    IdInformationPersonnelle INTEGER,
    IdRole INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdRole) REFERENCES Role(Id)
);

-- =========================
-- PERSONNEL
-- =========================

CREATE TABLE Personnelle (
    Id INTEGER,
    Matricule INTEGER,
    Prenom VARCHAR(30),
    Nom VARCHAR(30),
    EtatPersonnelle VARCHAR(50),
    IdDirection INTEGER,
    IdProvince INTEGER,
    IdSiteLocal INTEGER,
    IdNumeroBureau INTEGER,
    PRIMARY KEY (Id, Matricule),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id)
);

-- =========================
-- ECHELLE ADMINISTRATIVE
-- =========================

CREATE TABLE Direction (
    Id INTEGER PRIMARY KEY,
    NomDirection VARCHAR(60),
    IdProvince INTEGER,
    IdSiteLocal INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id)
);

CREATE TABLE Departement (
    Id INTEGER PRIMARY KEY,
    NomDepartement VARCHAR(60),
    IdDirection INTEGER,
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

CREATE TABLE Division (
    Id INTEGER PRIMARY KEY,
    NomDivision VARCHAR(60),
    IdDepartement INTEGER,
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id)
);

CREATE TABLE Service (
    Id INTEGER PRIMARY KEY,
    NomService VARCHAR(60),
    IdDivision INTEGER,
    FOREIGN KEY (IdDivision) REFERENCES Division(Id)
);

-- =========================
-- SITES
-- =========================

CREATE TABLE Province (
    Id INTEGER PRIMARY KEY,
    NomProvince VARCHAR(25)
);

CREATE TABLE TypeSiteLocal (
    Id INTEGER PRIMARY KEY,
    NomTypeSite VARCHAR(25)
);

CREATE TABLE SiteLocal (
    Id INTEGER,
    CodeSite INTEGER,
    NomSiteLocal VARCHAR(35),
    IdTypeSiteLocal INTEGER,
    IdProvince INTEGER,
    PRIMARY KEY (Id, CodeSite),
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdTypeSiteLocal) REFERENCES TypeSiteLocal(Id)
);

CREATE TABLE NumeroBureau (
    Id INTEGER PRIMARY KEY,
    NumBureau VARCHAR(15),
    IdNumeroEtage INTEGER,
    IdSiteLocal INTEGER,
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id)
);

CREATE TABLE NumeroEtage (
    Id INTEGER PRIMARY KEY,
    NumeroEtage VARCHAR(15)
);
-- =========================
-- LISTE DES MATERIELS
-- =========================

CREATE TABLE ListeMateriel (
    Id INTEGER, 
    NumeroSerie VARCHAR(50),
    NumeroInventaire VARCHAR(8),
    EtatMateriel VARCHAR(25),
    IdLivraisonStock INTEGER,
    PRIMARY KEY (Id, NumeroSerie),
    FOREIGN KEY (IdLivraisonStock) REFERENCES LivraisonStock(Id)
);

-- =========================
-- LIVRAISON & STOCK
-- =========================

CREATE TABLE LivraisonStock (
    Id INTEGER PRIMARY KEY,
    QuantiteLivraison INTEGER,
    DateLivraison DATE,
    ReferenceLivraison VARCHAR(25),
    IdMateriel INTEGER,
    FOREIGN KEY (IdMateriel) REFERENCES Materiel(Id)
);

-- =========================
-- AFFECTATION
-- =========================

CREATE TABLE AffectationMateriel (
    Id INTEGER PRIMARY KEY,
    DateDebut DATE,
    DateFin DATE,
    IdInformationPersonnelle INTEGER,
    IdListeMateriel INTEGER,
    IdDirection INTEGER,
    IdDepartement INTEGER,
    IdDivision INTEGER,
    IdService INTEGER,
    IdSiteLocal INTEGER,
    IdNumeroBureau INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdListeMateriel) REFERENCES ListeMateriel(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id),
    FOREIGN KEY (IdDivision) REFERENCES Division(Id),
    FOREIGN KEY (IdService) REFERENCES Service(Id),
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id)
);

-- =========================
-- RESSOURCES MATERIELS
-- =========================

CREATE TABLE MaterielCategorie (
    Id INTEGER PRIMARY KEY,
    NomCategorie VARCHAR(55)
);
 
CREATE TABLE MaterielMarque (
    Id INTEGER PRIMARY KEY,
    NomMarque VARCHAR(25)
);

CREATE TABLE MaterielModele (
    Id INTEGER PRIMARY KEY,
    NomModele VARCHAR(65),
    IdMaterielMarque INTEGER,
    FOREIGN KEY (IdMaterielMarque) REFERENCES MaterielMarque(Id)
);

CREATE TABLE Materiel (
    Id INTEGER PRIMARY KEY,
    MaterielDescription VARCHAR(120),
    MaterielQuantite INTEGER,
    MaterielGarantie INTEGER,
    PrixUnitaire DECIMAL(4,2),
    IdMaterielCategorie INTEGER,
    IdMarcheAppelOffre INTEGER,
    IdMaterielModele INTEGER,
    FOREIGN KEY (IdMaterielCategorie) REFERENCES MaterielCategorie(Id),
    FOREIGN KEY (IdMarcheAppelOffre) REFERENCES MarcheAppelOffre(Id),
    FOREIGN KEY (IdMaterielModele) REFERENCES MaterielModele(Id)
);

-- =========================
-- ACHAT & FOURNISSEURS
-- =========================

CREATE TABLE Fournisseur (
    Id INTEGER PRIMARY KEY,
    NomFournisseur VARCHAR(25),
    AdresseFournisseur VARCHAR(120),
    TelephoneFournisseur VARCHAR(15),
    ContactPersonne VARCHAR(255)
);

CREATE TABLE MarcheAppelOffre (
    Id INTEGER PRIMARY KEY,
    TitreMarche VARCHAR(70),
    NumeroMarche VARCHAR(20),
    DescriptionMarche VARCHAR(120),
    DateMarche DATE,
    IdFournisseur INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id)
);

CREATE TABLE Facture (
    Id INTEGER PRIMARY KEY,
    NumeroFacture VARCHAR(25),
    DateFacture DATE,
    MontantHT DECIMAL(8,2),
    TauxTVA INTEGER,
    MontantTTC DECIMAL(8,2),
    IdFournisseur INTEGER,
    IdMarcheAppelOffre INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdMarcheAppelOffre) REFERENCES MarcheAppelOffre(Id)
);
