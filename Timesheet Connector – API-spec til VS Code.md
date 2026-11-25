# Timesheet Connector – API-spec til VS Code

Dette er en opgavebeskrivelse til AI-agenten i VS Code. Koden skal ligge i mappen Timesheet i repoet Project Timesheet Connector (AL-Go).

## Overordnet formål

Vi laver en AL-app med custom API-sider (ikke standard-API), som en Azure Function i C# kan kalde. Functionen læser projekter, projektopgaver, ressourcer og arbejdstyper fra BC, og skriver timer tilbage som projektkladdelinjer, som bogføres manuelt i BC.

## Fælles regler for alle sider

- Objekt-ID'er starter ved 60100.
- PageType = API, APIPublisher = 'soeren', APIGroup = 'timesheet', APIVersion = 'v1.0'.
- ODataKeyFields = SystemId, og feltet id er altid SystemId.
- Alle sider har lastModifiedDateTime (SystemModifiedAt), så Functionen kan hente ændringer siden sidste kørsel med et filter.
- Feltnavne i camelCase på engelsk.
- Læsesider er skrivebeskyttede: Editable, InsertAllowed, ModifyAllowed og DeleteAllowed er false.
- Brug Rec."Felt" og følg BC Quality-reglerne og AL best practices.
- Lav en permission set, der giver adgang til siderne og de underliggende tabeller, så en app-registrering (S2S) kan bruge den.

## Side 1: Projekter (læs)

Kildetabel Job. EntityName project, EntitySetName projects.

Felter: id, number (No.), description, customerNumber (Bill-to Customer No.), customerName (Bill-to Name), status, personResponsible, blocked, lastModifiedDateTime.

Filtrér så kun projekter med status Åben og som ikke er blokeret vises.

Undersiden projectTasks (side 2) skal kunne hentes med $expand.

## Side 2: Projektopgaver (læs)

Kildetabel Job Task. EntityName projectTask, EntitySetName projectTasks.

Felter: id, projectNumber (Job No.), number (Job Task No.), description, taskType (Job Task Type), lastModifiedDateTime.

Vis kun opgaver hvor Job Task Type er Posting, fordi man ikke kan registrere på overskrifter og totaler. Siden bruges både som selvstændig side og som del af projekter.

## Side 3: Ressourcer (læs)

Kildetabel Resource. EntityName resource, EntitySetName resources.

Felter: id, number (No.), name, type (Person/Machine), baseUnitOfMeasure, blocked, lastModifiedDateTime.

Vis kun ikke-blokerede ressourcer.

## Side 4: Arbejdstyper (læs)

Kildetabel Work Type. EntityName workType, EntitySetName workTypes.

Felter: id, code, description, unitOfMeasureCode, lastModifiedDateTime.

## Side 5: Tidsregistreringer (skriv)

Kildetabel Job Journal Line. EntityName timeEntry, EntitySetName timeEntries. Denne side må oprette linjer (InsertAllowed = true, DelayedInsert = true).

Felter Functionen sender: externalId (gemmes i External Document No.), projectNumber (Job No.), projectTaskNumber (Job Task No.), resourceNumber (No. med Type = Resource), workTypeCode, postingDate, quantity (timer), description.

Felter siden selv udfylder: Journal Template Name og Journal Batch Name fra en opsætning (se nedenfor), Line No. som næste ledige nummer i kladden, Type = Resource, Document No. fra kladdens nummerserie.

Siden skal også kunne læses med GET, så Functionen kan tjekke at en linje er kommet ind, fx med filter på externalId. Hold det simpelt: det er et demoprojekt, ikke en fuld løsning.

Regler:

- Validér felterne i rigtig rækkefølge med Validate, så BC's egen logik kører (projekt, opgave, type, nummer, arbejdstype, antal).
- Afvis en linje, hvis externalId allerede findes i kladden, så samme registrering ikke kommer ind to gange.
- Returnér tydelige fejl, hvis projekt, opgave eller ressource ikke findes eller er spærret.

## Bogføring

Appen bogfører ikke. Linjerne lægges kun i projektkladden, og bogføringen sker manuelt i BC. Der skal ikke laves en action eller codeunit til bogføring.

## Opsætning

Lav en lille opsætningstabel og -side (Timesheet Connector Setup) med Journal Template Name og Journal Batch Name, så det styres hvilken projektkladde linjerne lander i.

## Test

Lav en .http-fil til REST Client i VS Code med eksempler på GET af projekter med $expand=projectTasks, GET af ressourcer og arbejdstyper, GET med filter på lastModifiedDateTime, og POST af en timeEntry.
