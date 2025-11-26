-- =========================
-- INFORMATION DES UTILISATEURS
-- =========================

CREATE TABLE Role (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomRole VARCHAR(30) UNIQUE NOT NULL,
    DescriptionRole VARCHAR(50) NOT NULL
);

CREATE TABLE Permission (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomPermission VARCHAR(30) UNIQUE NOT NULL,
    DescriptionPermission VARCHAR(50) NOT NULL
);

CREATE TABLE RolePermission (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    IdRole INTEGER,
    IdPermission INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdPermission) REFERENCES Permission(Id)
);

CREATE TABLE Utilisateur (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Email VARCHAR(30) UNIQUE NOT NULL,
    MotDePasse VARCHAR(8) NOT NULL,
    EtatUtilisateur VARCHAR(50) NOT NULL,
    IdInformationPersonnelle INTEGER,
    IdRole INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdRole) REFERENCES Role(Id)
);

-- =========================
-- PERSONNEL
-- =========================

CREATE TABLE Personnelle (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Matricule INTEGER UNIQUE NOT NULL,
    Prenom VARCHAR(30) NOT NULL,
    Nom VARCHAR(30) NOT NULL,
    EtatPersonnelle VARCHAR(50) NOT NULL,
    IdDirection INTEGER,
    IdProvince INTEGER,
    IdSiteLocal INTEGER,
    IdNumeroBureau INTEGER,
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id)
);

-- =========================
-- ECHELLE ADMINISTRATIVE
-- =========================

CREATE TABLE Direction (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDirection VARCHAR(60) NOT NULL,
    IdProvince INTEGER,
    IdSiteLocal INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id)
);

CREATE TABLE Departement (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDepartement VARCHAR(60) NOT NULL,
    IdDirection INTEGER,
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

CREATE TABLE Division (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDivision VARCHAR(60) NOT NULL,
    IdDepartement INTEGER,
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id)
);

CREATE TABLE Service (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomService VARCHAR(60) NOT NULL,
    IdDivision INTEGER,
    FOREIGN KEY (IdDivision) REFERENCES Division(Id)
);

-- =========================
-- SITES
-- =========================

CREATE TABLE Province (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomProvince VARCHAR(25) NOT NULL
);

CREATE TABLE TypeSiteLocal (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomTypeSite VARCHAR(25) NOT NULL
);

CREATE TABLE SiteLocal (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CodeSite VARCHAR(25) UNIQUE NOT NULL,
    NomSiteLocal VARCHAR(35) NOT NULL,
    IdTypeSiteLocal INTEGER,
    IdProvince INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdTypeSiteLocal) REFERENCES TypeSiteLocal(Id)
);

CREATE TABLE NumeroBureau (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumBureau VARCHAR(15) NOT NULL,
    IdNumeroEtage INTEGER,
    IdSiteLocal INTEGER,
    FOREIGN KEY (IdSiteLocal) REFERENCES SiteLocal(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id)
);

CREATE TABLE NumeroEtage (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumeroEtage VARCHAR(20) UNIQUE NOT NULL
);
-- =========================
-- LISTE DES MATERIELS
-- =========================

CREATE TABLE ListeMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT, 
    NumeroSerie VARCHAR(50) UNIQUE NOT NULL,
    NumeroInventaire VARCHAR(8) NOT NULL,
    EtatMateriel VARCHAR(25) NOT NULL,
    IdLivraisonStock INTEGER,
    FOREIGN KEY (IdLivraisonStock) REFERENCES LivraisonStock(Id)
);

-- =========================
-- LIVRAISON & STOCK
-- =========================

CREATE TABLE LivraisonStock (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    QuantiteLivraison INTEGER CHECK (QuantiteLivraison > 0),
    DateLivraison DATE NOT NULL,
    ReferenceLivraison VARCHAR(25) NOT NULL,
    IdMateriel INTEGER,
    FOREIGN KEY (IdMateriel) REFERENCES Materiel(Id)
);

-- =========================
-- AFFECTATION
-- =========================

CREATE TABLE AffectationMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    DateDebut DATE NOT NULL,
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
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomCategorie VARCHAR(55) NOT NULL
);
 
CREATE TABLE MaterielMarque (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomMarque VARCHAR(25) NOT NULL
);

CREATE TABLE MaterielModele (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomModele VARCHAR(65) NOT NULL,
    IdMaterielMarque INTEGER,
    FOREIGN KEY (IdMaterielMarque) REFERENCES MaterielMarque(Id)
);

CREATE TABLE Materiel (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    MaterielDescription VARCHAR(120) NOT NULL,
    MaterielQuantite INTEGER CHECK (MaterielQuantite > 0),
    MaterielGarantie INTEGER CHECK (MaterielGarantie > 0),
    PrixUnitaire DECIMAL(4,2) CHECK (PrixUnitaire > 0),
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
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomFournisseur VARCHAR(25) NOT NULL,
    AdresseFournisseur VARCHAR(120) NOT NULL,
    TelephoneFournisseur VARCHAR(15) NOT NULL,
    ContactPersonne VARCHAR(30) NOT NULL
);

CREATE TABLE MarcheAppelOffre (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    TitreMarche VARCHAR(70) NOT NULL,
    NumeroMarche VARCHAR(20) NOT NULL,
    DescriptionMarche VARCHAR(120) NOT NULL,
    DateMarche DATE NOT NULL UNIQUE,
    IdFournisseur INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id)
);

CREATE TABLE Facture (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NumeroFacture VARCHAR(25) NOT NULL,
    DateFacture DATE NOT NULL,
    MontantHT DECIMAL(8,2) CHECK (MontantHT > 0),
    TauxTVA INTEGER NOT NULL,
    MontantTTC DECIMAL(8,2) CHECK (MontantTTC > 0),
    IdFournisseur INTEGER,
    IdMarcheAppelOffre INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdMarcheAppelOffre) REFERENCES MarcheAppelOffre(Id)
);
