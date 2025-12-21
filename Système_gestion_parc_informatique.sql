-- ====================
-- MODULE: AFFECTATION
-- ====================

CREATE TABLE AffectationMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    DateAffectation DATE NOT NULL,
    DateCloture DATE,
    IdPersonnelle INTEGER,
    IdChampPersoImmobi INTEGER,
    IdDirection INTEGER,
    IdDepartement INTEGER,
    IdDivision INTEGER,
    IdService INTEGER,
    IdProvince INTEGER,
    IdListeSite INTEGER,
    IdNumeroEtage INTEGER,
    IdNumeroBureau INTEGER,
    FOREIGN KEY (IdPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdChampPersoImmobi) REFERENCES ChampPersoImmobi(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id),
    FOREIGN KEY (IdDivision) REFERENCES Division(Id),
    FOREIGN KEY (IdService) REFERENCES Service(Id),
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id)
);

-- =====================================
-- MODULE: IMMOBILISATION DES MATERIELS 
-- =====================================

-- CREATE TABLE ListeMateriel (
--     Id INT PRIMARY KEY AUTO_INCREMENT, 
--     NumeroSerie VARCHAR(50) UNIQUE NOT NULL,
--     NumeroInventaire VARCHAR(8) NOT NULL,
--     EtatMateriel VARCHAR(25),
--     IdLivraisonStock INTEGER,
--     FOREIGN KEY (IdLivraisonStock) REFERENCES LivraisonStock(Id)
-- );

CREATE TABLE ImmobilisationMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    EtatMateriel VARCHAR(25),
    IdTypeMateriel INTEGER,
    FOREIGN KEY (IdTypeMateriel) REFERENCES TypeMateriel(Id),
);

CREATE TABLE ChampPersoImmobi (
    Id INT PRIMARY KEY AUTO_INCREMENT, 
    NumeroSerie VARCHAR(50) UNIQUE NOT NULL,
    NumeroInvantaire VARCHAR(8) UNIQUE NOT NULL,
    IdImmobilisationMateriel INTEGER,
    FOREIGN KEY (IdImmobilisationMateriel) REFERENCES ImmobilisationMateriel(Id)
);

-- ===========================
-- MODULE: LIVRAISON MATERIEL
-- ===========================

CREATE TABLE LivraisonMateriel (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    QuantiteLivraison INTEGER CHECK (QuantiteLivraison > 0),
    DateLivraison DATE,
    ReferenceLivraison VARCHAR(25) UNIQUE,
    IdListeMarche INTEGER,
    IdListMateriel INTEGER,
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
    FOREIGN KEY (IdListMateriel) REFERENCES ListMateriel(Id)
);

-- =========================
-- MODULE: GESTION PERSONNEL
-- =========================

CREATE TABLE Personnelle (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    Matricule VARCHAR(15) UNIQUE NOT NULL,
    Nom VARCHAR(30),
    Prenom VARCHAR(30),
    Email VARCHAR(30) UNIQUE,
    NTelephone VARCHAR(15) UNIQUE,
    IdGrade INTEGER,
    IdEtatAdministratif INTEGER,
    IdNumeroBureau INTEGER,
    IdDirection INTEGER,
    IdDepartement INTEGER,
    IdDivision INTEGER,
    IdService INTEGER,
    FOREIGN KEY (IdGrade) REFERENCES Grade(Id),
    FOREIGN KEY (IdEtatAdministratif) REFERENCES EtatAdministratif(Id),
    FOREIGN KEY (IdNumeroBureau) REFERENCES NumeroBureau(Id),
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id),
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id),
    FOREIGN KEY (IdDivision) REFERENCES Division(Id),
    FOREIGN KEY (IdService) REFERENCES Service(Id)
);

CREATE TABLE Grade (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomGrade VARCHAR(50) UNIQUE
);

CREATE TABLE EtatAdministratif (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomEtatAdministratif VARCHAR(50) UNIQUE
);

-- ============================
-- MODULE: Gestion UTILISATEUR
-- ============================

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
    EtatUtilisateur VARCHAR(15) UNIQUE NOT NULL,
    IdInformationPersonnelle INTEGER,
    IdRole INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdRole) REFERENCES Role(Id)
);

-- =============================
-- MODULE: RESSOURCES MATERIELS
-- =============================

-- CREATE TABLE Categorie (
--     Id INTEGER PRIMARY KEY AUTO_INCREMENT,
--     NomCategorie VARCHAR(55) UNIQUE
-- );

CREATE TABLE TypeMateriel (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomTypeMateriel VARCHAR(55) UNIQUE,
    IdListMateriel INTEGER,
    IdModele INTEGER,
    FOREIGN KEY (IdListMateriel) REFERENCES ListMateriel(Id),
    FOREIGN KEY (IdModele) REFERENCES Modele(Id)
);

-- CREATE TABLE NomMateriel (
--     Id INTEGER PRIMARY KEY AUTO_INCREMENT,
--     NomMateriel VARCHAR(55) UNIQUE,
--     IdCategorie INTEGER,
--     FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id)
-- );

CREATE TABLE Marque (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomMarque VARCHAR(25) UNIQUE
);

CREATE TABLE Modele (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomModele VARCHAR(65) UNIQUE,
    IdMarque INTEGER,
    -- IdCategorie INTEGER,
    -- IdNomMateriel INTEGER,
    FOREIGN KEY (IdMarque) REFERENCES Marque(Id),
    -- FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id),
    -- FOREIGN KEY (IdNomMateriel) REFERENCES NomMateriel(Id)
);

CREATE TABLE ListMateriel (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomMateriel VARCHAR(55),
    Caracteristique VARCHAR(120),
    Quantite INTEGER CHECK (Quantite > 0),
    Garantie INTEGER CHECK (Garantie > 0),
    PrixUnitaire DECIMAL(6,2) CHECK (PrixUnitaire > 0),
    -- IdCategorie INTEGER,
    -- IdNomMateriel INTEGER,
    -- IdMarque INTEGER,
    -- IdModele INTEGER,
    -- IdFournisseur INTEGER,
    IdListeMarche INTEGER,
    -- FOREIGN KEY (IdNomMateriel) REFERENCES NomMateriel(Id),
    -- FOREIGN KEY (IdCategorie) REFERENCES Categorie(Id),
    -- FOREIGN KEY (IdMarque) REFERENCES Marque(Id),
    -- FOREIGN KEY (IdModele) REFERENCES Modele(Id),
    -- FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);

-- ==============================
-- MODULE: ECHELLE ADMINISTRATIVE
-- ==============================

CREATE TABLE Direction (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomDirection VARCHAR(60) UNIQUE NOT NULL,
    IdListeSite INTEGER,
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id)
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
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id)
);

CREATE TABLE Service (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomService VARCHAR(60),
    IdDivision INTEGER,
    FOREIGN KEY (IdDivision) REFERENCES Division(Id)
);

-- =====================
-- MODULE: SITES LOCAUX
-- =====================

CREATE TABLE Province (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomProvince VARCHAR(25) UNIQUE
);

CREATE TABLE TypeSite (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NomTypeSite VARCHAR(25) UNIQUE
);

CREATE TABLE ListeSite (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    CodeSite VARCHAR(25) UNIQUE,
    NomSite VARCHAR(35) UNIQUE,
    IdTypeSite INTEGER,
    IdProvince INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdTypeSite) REFERENCES TypeSite(Id)
);

CREATE TABLE NumeroEtage (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumeroEtage VARCHAR(20) UNIQUE
);

CREATE TABLE NumeroBureau (
    Id INT PRIMARY KEY AUTO_INCREMENT,
    NumBureau VARCHAR(15),
    IdNumeroEtage INTEGER,
    IdListeSite INTEGER,
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id)
);

-- ==============================
-- MODULE: MARCHES & FOURNISSEURS
-- ==============================

CREATE TABLE Fournisseur (
    Id INTEGER PRIMARY KEY AUTO_INCREMENT,
    NomFournisseur VARCHAR(25) UNIQUE,
    Adresse VARCHAR(120) UNIQUE,
    Telephone VARCHAR(15) UNIQUE,
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
    -- IdFournisseur INTEGER,
    IdListeMarche INTEGER,
    -- FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id),
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);
