-- =========================
-- INFORMATION DES UTILISATEURS
-- =========================

CREATE TABLE Permission (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomPermission VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE RolePermission (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    IdRole INTEGER,
    IdPermission INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdPermission) REFERENCES Permission(Id)
);

CREATE TABLE Role (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomRole VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE RoleUtilisateur (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    IdRole INTEGER,
    IdUtilisateur INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur(Id)
);

CREATE TABLE Utilisateur (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    MotDePasse VARCHAR(8) NOT NULL,
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
    Matricule VARCHAR(15) UNIQUE,
    Nom VARCHAR(30),
    Prenom VARCHAR(30),
    EtatAdministratif VARCHAR(50),
    Email VARCHAR(30) UNIQUE,
    NTelephone VARCHAR(15) UNIQUE,
);

-- =========================
-- ECHELLE ADMINISTRATIVE
-- =========================

CREATE TABLE Direction (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDirection VARCHAR(60)
);

CREATE TABLE Departement (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDepartement VARCHAR(60),
    IdDirection INTEGER,
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

CREATE TABLE Division (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDivision VARCHAR(60),
    IdDepartement INTEGER,
    IdDirection INTEGER,
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

CREATE TABLE Service (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomService VARCHAR(60),
    IdDivision INTEGER,
    IdDirection INTEGER,
    FOREIGN KEY (IdDivision) REFERENCES Division(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

-- =========================
-- SITES
-- =========================

CREATE TABLE Province (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomProvince VARCHAR(25)
);

CREATE TABLE TypeSite (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomTypeSite VARCHAR(25)
);

CREATE TABLE ListeSite (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CodeSite VARCHAR(25) UNIQUE,
    NomSite VARCHAR(35),
    IdTypeSite INTEGER,
    IdProvince INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdTypeSite) REFERENCES TypeSite(Id)
);

CREATE TABLE NumeroBureau (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumBureau VARCHAR(15),
    IdNumeroEtage INTEGER,
    IdListeSite INTEGER,
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id)
);

CREATE TABLE NumeroEtage (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumeroEtage VARCHAR(20) UNIQUE
);

-- =========================
-- AFFECTATION
-- =========================

CREATE TABLE AffectationMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    DateAffectation DATE,
    DateCloture DATE,
    IdInformationPersonnelle INTEGER,
    IdListeMateriel INTEGER,
    IdDirection INTEGER,
    IdDepartement INTEGER,
    IdDivision INTEGER,
    IdService INTEGER,
    IdProvince INTEGER,
    IdListeSite INTEGER,
    IdNumeroEtage INTEGER,
    IdNumeroBureau INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdListeMateriel) REFERENCES ListeMateriel(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id),
    FOREIGN KEY (IdDivision) REFERENCES Division(Id),
    FOREIGN KEY (IdService) REFERENCES Service(Id),
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id)
);

-- =========================
-- LISTE DES MATERIELS
-- =========================

CREATE TABLE ListeMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT, 
    NumeroSerie VARCHAR(50) UNIQUE NOT NULL,
    NumeroInventaire VARCHAR(8) NOT NULL,
    EtatMateriel VARCHAR(25),
    IdLivraisonStock INTEGER,
    FOREIGN KEY (IdLivraisonStock) REFERENCES LivraisonStock(Id)
);

-- =========================
-- LIVRAISON & STOCK
-- =========================

CREATE TABLE LivraisonStock (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    QuantiteLivraison INTEGER CHECK (QuantiteLivraison > 0),
    DateLivraison DATE,
    ReferenceLivraison VARCHAR(25) UNIQUE,
    IdListeMarche INTEGER,
    IdMateriel INTEGER,
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id),
    FOREIGN KEY (IdMateriel) REFERENCES Materiel(Id)
);

-- =========================
-- RESSOURCES MATERIELS
-- =========================

CREATE TABLE Categorie (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomCategorie VARCHAR(55)
);

CREATE TABLE NomMateriel (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    Nom VARCHAR(55),
    IdCategorie INTEGER,
    FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id)
);

CREATE TABLE Marque (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomMarque VARCHAR(25)
);

CREATE TABLE Modele (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomModele VARCHAR(65),
    IdMarque INTEGER,
    IdCategorie INTEGER,
    IdNomMateriel INTEGER,
    FOREIGN KEY (IdMarque) REFERENCES Marque(Id),
    FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id),
    FOREIGN KEY (IdNomMateriel) REFERENCES NomMateriel(Id)
);

CREATE TABLE Materiel (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    MDescription VARCHAR(120),
    Quantite INTEGER CHECK (MaterielQuantite > 0),
    Garantie INTEGER CHECK (MaterielGarantie > 0),
    PrixUnitaire DECIMAL(4,2) CHECK (PrixUnitaire > 0),
    IdCategorie INTEGER,
    IdNomMateriel INTEGER,
    IdMarque INTEGER,
    IdModele INTEGER,
    IdFournisseur INTEGER,
    IdListeMarche INTEGER,
    FOREIGN KEY (IdNomMateriel) REFERENCES NomMateriel(Id),
    FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id),
    FOREIGN KEY (IdMarque) REFERENCES Marque(Id),
    FOREIGN KEY (IdModele) REFERENCES Modele(Id),
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);

-- =========================
-- ACHAT & FOURNISSEURS
-- =========================

CREATE TABLE Fournisseur (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomFournisseur VARCHAR(25),
    Adresse VARCHAR(120),
    Telephone VARCHAR(15),
    ContactPersonne VARCHAR(30)
);

CREATE TABLE ListeMarche (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    TitreMarche VARCHAR(70),
    NumeroMarche VARCHAR(20) UNIQUE,
    DateMarche DATE UNIQUE,
    IdFournisseur INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id)
);

CREATE TABLE Facture (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NumeroFacture VARCHAR(25) UNIQUE,
    DateFacture DATE,
    MontantHT DECIMAL(8,2) CHECK (MontantHT > 0),
    TauxTVA INTEGER CHECK (TauxTVA >= 0),
    MontantTTC DECIMAL(8,2) CHECK (MontantTTC > 0),
    IdFournisseur INTEGER,
    IdListeMarche INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);
