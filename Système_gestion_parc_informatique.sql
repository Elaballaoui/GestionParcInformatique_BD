-- ============================
-- MODULE: Gestion UTILISATEUR
-- ============================

CREATE TABLE Permission (
    Id SERIAL PRIMARY KEY,
    NomPermission VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE Role (
    Id SERIAL PRIMARY KEY,
    NomRole VARCHAR(30) UNIQUE NOT NULL
);

CREATE TABLE RolePermission (
    Id SERIAL PRIMARY KEY,
    IdRole INTEGER,
    IdPermission INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdPermission) REFERENCES Permission(Id)
);

-- ========================
-- MODULE: GESTION MARCHES 
-- ========================

CREATE TABLE Fournisseur (
    Id SERIAL PRIMARY KEY,
    NomFournisseur VARCHAR(25) UNIQUE,
    Adresse VARCHAR(120) UNIQUE,
    Telephone VARCHAR(15) UNIQUE,
    ContactPersonne VARCHAR(30) 
);

CREATE TABLE ListeMarche (
    Id SERIAL PRIMARY KEY,
    TitreMarche VARCHAR(70),
    NumeroMarche VARCHAR(20) UNIQUE,
    DateMarche DATE,
    IdFournisseur INTEGER,
    FOREIGN KEY (IdFournisseur) REFERENCES Fournisseur(Id)
);

CREATE TABLE Facture (
    Id SERIAL PRIMARY KEY,
    NumeroFacture VARCHAR(25) UNIQUE,
    DateFacture DATE,
    MontantHT DECIMAL(8,2) CHECK (MontantHT > 0),
    TauxTVA INTEGER CHECK (TauxTVA >= 0),
    MontantTTC DECIMAL(8,2) CHECK (MontantTTC > 0),
    IdListeMarche INTEGER,
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);

CREATE TABLE ListMateriel (
    Id SERIAL PRIMARY KEY,
    NomMateriel VARCHAR(55),
    Caracteristique VARCHAR(120),
    Quantite INTEGER CHECK (Quantite > 0),
    Garantie INTEGER CHECK (Garantie > 0),
    PrixUnitaire DECIMAL(6,2) CHECK (PrixUnitaire > 0),
    IdListeMarche INTEGER,
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id)
);

-- =============================
-- MODULE: RESSOURCES MATERIELS
-- =============================

CREATE TABLE Marque (
    Id SERIAL PRIMARY KEY,
    NomMarque VARCHAR(25) UNIQUE
);

CREATE TABLE Modele (
    Id SERIAL PRIMARY KEY,
    NomModele VARCHAR(65) UNIQUE,
    IdMarque INTEGER,
    FOREIGN KEY (IdMarque) REFERENCES Marque(Id)
);

CREATE TABLE TypeMateriel (
    Id SERIAL PRIMARY KEY,
    NomTypeMateriel VARCHAR(55) UNIQUE,
    IdListMateriel INTEGER,
    IdModele INTEGER,
    FOREIGN KEY (IdListMateriel) REFERENCES ListMateriel(Id),
    FOREIGN KEY (IdModele) REFERENCES Modele(Id)
);

-- ===========================
-- MODULE: LIVRAISON MATERIEL
-- ===========================

CREATE TABLE LivraisonMateriel (
    Id SERIAL PRIMARY KEY,
    QuantiteLivraison INTEGER CHECK (QuantiteLivraison > 0),
    DateLivraison DATE,
    ReferenceLivraison VARCHAR(25) UNIQUE,
    IdListeMarche INTEGER,
    IdListMateriel INTEGER,
    FOREIGN KEY (IdListeMarche) REFERENCES ListeMarche(Id),
    FOREIGN KEY (IdListMateriel) REFERENCES ListMateriel(Id)
);

-- =====================================
-- MODULE: IMMOBILISATION DES MATERIELS 
-- =====================================

CREATE TABLE ImmobilisationMateriel (
    Id SERIAL PRIMARY KEY,
    EtatMateriel VARCHAR(25),
    IdTypeMateriel INTEGER,
    FOREIGN KEY (IdTypeMateriel) REFERENCES TypeMateriel(Id)
);

CREATE TABLE ChampPersoImmobi (
    Id SERIAL PRIMARY KEY, 
    NumeroSerie VARCHAR(50) UNIQUE NOT NULL,
    NumeroInvantaire VARCHAR(8) UNIQUE NOT NULL,
    IdImmobilisationMateriel INTEGER,
    FOREIGN KEY (IdImmobilisationMateriel) REFERENCES ImmobilisationMateriel(Id)
);

-- ==============================
-- MODULE: ECHELLE ADMINISTRATIVE
-- ==============================

CREATE TABLE Province (
    Id SERIAL PRIMARY KEY,
    NomProvince VARCHAR(25) UNIQUE
);

CREATE TABLE TypeSite (
    Id SERIAL PRIMARY KEY,
    NomTypeSite VARCHAR(25) UNIQUE
);

CREATE TABLE ListeSite (
    Id SERIAL PRIMARY KEY,
    CodeSite VARCHAR(25) UNIQUE,
    NomSite VARCHAR(35) UNIQUE,
    IdTypeSite INTEGER,
    IdProvince INTEGER,
    FOREIGN KEY (IdProvince) REFERENCES Province(Id),
    FOREIGN KEY (IdTypeSite) REFERENCES TypeSite(Id)
);

CREATE TABLE NumeroEtage (
    Id SERIAL PRIMARY KEY,
    NumeroEtage VARCHAR(20) UNIQUE
);

CREATE TABLE NumeroBureau (
    Id SERIAL PRIMARY KEY,
    NumBureau VARCHAR(15),
    IdNumeroEtage INTEGER,
    IdListeSite INTEGER,
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id),
    FOREIGN KEY (IdNumeroEtage) REFERENCES NumeroEtage(Id)
);

CREATE TABLE Direction (
    Id SERIAL PRIMARY KEY,
    NomDirection VARCHAR(60) UNIQUE NOT NULL,
    IdListeSite INTEGER,
    FOREIGN KEY (IdListeSite) REFERENCES ListeSite(Id)
);

CREATE TABLE Departement (
    Id SERIAL PRIMARY KEY,
    NomDepartement VARCHAR(60),
    IdDirection INTEGER,
    FOREIGN KEY (IdDirection) REFERENCES Direction(Id)
);

CREATE TABLE Division (
    Id SERIAL PRIMARY KEY,
    NomDivision VARCHAR(60),
    IdDepartement INTEGER,
    FOREIGN KEY (IdDepartement) REFERENCES Departement(Id)
);

CREATE TABLE Service (
    Id SERIAL PRIMARY KEY,
    NomService VARCHAR(60),
    IdDivision INTEGER,
    FOREIGN KEY (IdDivision) REFERENCES Division(Id)
);

-- =========================
-- MODULE: GESTION PERSONNEL
-- =========================

CREATE TABLE Grade (
    Id SERIAL PRIMARY KEY,
    NomGrade VARCHAR(50) UNIQUE
);

CREATE TABLE EtatAdministratif (
    Id SERIAL PRIMARY KEY,
    NomEtatAdministratif VARCHAR(50) UNIQUE
);

CREATE TABLE Personnelle (
    Id SERIAL PRIMARY KEY,
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

CREATE TABLE Utilisateur (
    Id SERIAL PRIMARY KEY,
    MotDePasse VARCHAR(8) NOT NULL,
    EtatUtilisateur VARCHAR(15) UNIQUE NOT NULL,
    IdInformationPersonnelle INTEGER,
    IdRole INTEGER,
    FOREIGN KEY (IdInformationPersonnelle) REFERENCES Personnelle(Id),
    FOREIGN KEY (IdRole) REFERENCES Role(Id)
);

CREATE TABLE RoleUtilisateur (
    Id SERIAL PRIMARY KEY,
    IdRole INTEGER,
    IdUtilisateur INTEGER,
    FOREIGN KEY (IdRole) REFERENCES Role(Id),
    FOREIGN KEY (IdUtilisateur) REFERENCES Utilisateur(Id)
);

-- ====================
-- MODULE: AFFECTATION
-- ====================

CREATE TABLE AffectationMateriel (
    Id SERIAL PRIMARY KEY,
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
