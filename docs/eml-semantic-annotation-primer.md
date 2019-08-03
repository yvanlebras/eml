# Semantic Annotation Primer

<a name="introduction"></a>

## Introduction

A semantic annotation is the attachment of semantic metadata to a resource - in this case, a dataset. 
What makes the annotation "semantic" is that the resource is linked to a well-defined term in an Ontology.  In this way, semantic annotation provides access to precise definitions of concepts, and clarifies the relationships among concepts in a machine-readable way, using the Web. The process of creating semantic annotations may seem tedious, but the payoff is enhanced discovery and reuse of your data. 

The main differences between semantic annotation and simply adding keywords are: 
- semantic annotations can be read and interpreted by computers 
- semantic annotations describe the relationship between a specific part of the metadata and terms in external vocabularies
- semantic annotations use W3C-recommended languages to express these relationships via the Web
 
In discussing further how annotation works within EML, we will assume that all mentions of "annotation" imply "semantic annotation", as described above.  That is, more generic methods for annotating data and metadata exist (e.g. using keywords), but these are not nearly as powerful as "semantic annotation".

**Benefits of annotation:** Annotations vastly enhance data discovery and interpretation. Semantic annotations will make it easier for others to find and reuse data (and thus give proper credit), including the following cases: 

1. **Finding synonymous concepts:** Assume one dataset uses the phrase "carbon dioxide flux" and another dataset "CO2 flux". 
An information system can recognize, through semantic annotation, that these datasets are about the "same" concepts, if the datasets were annotated using the same term identifier for that measurement. 
1. **Disambiguating terms:**  If datasets have been annotated, the system can assist in providing only results relevant for your intended meaning. For example, if you are searching for datasets about "litter" (as in "plant litter"). other irrelevant terms also labelled as "litter" (e.g., "garbage" or a "group of animals born together") can be eliminated from your search results. This is because each distinct type of "litter" would be associated with a different identifier. 
1. **Hierarchical searches:** If you search for datasets containing "carbon flux" measurements, then datasets annotated as having measurements of "carbon dioxide flux" or "CO2 flux" will also be returned, because these are both types of "carbon flux".  This is possible if the concepts come from a structured vocabulary where "carbon dioxide flux" is lower down in the hierarchy (i.e. is a subclass) of "carbon flux".


EML 2.2.0 now provides ways to embed references to terms in *[external vocabularies](#external-vocabularies)* (also known as *ontologies*) using HTTP [uniform resource identifiers](#glossary-uri) (or URIs). The association of an element in an EML metadata document with that external reference, is a *semantic annotation*. By referencing terms from an external vocabulary, one can provide a rigorous, expressive and consistent interpretation of the metadata.  This is only true, however, if the external vocabulary itself is well-constructed, and expressed in a W3C semantic web language. . Since the external reference (or annotation) is to a *controlled vocabulary* or *[ontology](#glossary-ontology)*, the annotation provides a computer-usable [pointer](#glossary-pointer) (the HTTP URI) that [resolves](#glossary-resolve) (and [dereferences](#glossary-dereference)) to a useful description, definition or other relationships for that annotated resource. The annotations can be extracted from an EML document, and re-expressed (formally, "serialized") into a Semantic Web language such as RDF or JSON-LD. Annotations (also called "assertions" or "triples" in RDF) collectively contribute to a *[knowledge graph](#glossary-knowledge-graph)*, that captures understanding of the relationship of the contents of datasets (as "instances") with the concepts represented by terms in ontologies (as "classes"). 


### Take-home messages

- **Semantic statements must be logically consistent, as they are not simply a set of loosely structured keywords.** 
- **EML 2.2.0 has five places or methods to add annotations.**  [[Margaret-- I don't see where you've mentioned this except further below, MPS]]
- **The best place for advice and feedback on EML annotations is your data management community**

### Organization of this document

The purpose of this Primer is to provide an introduction to how semantic 
annotations are structured in EML documents. It is expected that you already have some familiarity with the EML schema, and
the focus of this document then, is explanation and examples of annotations in EML. 
This Primer is divided into three major sections. You should be able to create EML annotations immediately, using 
only the main section [Semantic Annotations in EML 2.2.0](#sa-eml22), referencing the [Appendix](#appendix) when 
you would like a longer explanation.[[what is the third section? MPS]]

 -  **[Introduction:](#introduction)** (this section)
 -  **[Semantic Annotations in EML 2.2.0](#sa-eml22)**, with examples. Where used, EML elements are shown as inline code blocks (`elementName`).
 -  **[Appendix](#appendix)** additional information on specific related topics, linked from the Introduction and Semantic Annotations in EML 2.2.0 section.
    - **[Glossary:](#glossary)** Glossary of terms, linked from text
    - **[Semantic triples:](#semantic-triples)**  details on their structure, and how that structure is leveraged by annotations with examples of their power
    - **[URIs:](#uris)** defined, and as components of semantic triples
    - **[RDF model:](#rdf)** brief description of the W3C's RDF model with example graphs based on EML annotations
    - **[Logical consistency:](#logical-consistency)** Common mistakes and how to check for them
    - **[Vocabularies and repositories used in examples:](#external-vocabularies)** Descriptions an links out to explore further
    - **[Supplemental background information:](#additional-background)** The EML annotation approach here is compatible with recommendations by the World Wide Web Consortium (W3C) for construction of the Semantic Web. A wealth of material is available; a few selected ones are here.
    - **[Frequently asked questions:](#FAQ)** Some questions asked by readers, and their answers


<a name="sa-eml22"></a>

## Semantic Annotations in EML 2.2.0

In **EML 2.2.0** there are 5 places where annotation elements can appear in an EML document: 

- **top-level resource**  -- an `annotation` element is a child of the `dataset`, `literature`, `software`, or `protocol` elements
- **entity-level** -- an `annotation` element is a child of a dataset's entity (e.g., `dataTable` )
- **attribute** -- an `annotation` element is a child of a dataset entity's `attribute` element
- **eml/annotations** -- a container for a group of `annotation` elements, using references
- **eml/additionalMetadata** -- `annotation` elements that reference a main-body element by its `id` attribute

### Annotation element structure

All annotation nodes are defined as an XML type, so they have the same structure anywhere they appear
in the EML record. Here is the basic structure. Sections below have more examples.

```xml
    <annotation>
        <propertyURI label="property label here">property URI here</propertyURI>
        <valueURI label="value label here">value URI here</valueURI>
    </annotation>
```

An annotation element always has a parent-EML element, which is the 'thing' being annotated, or the *subject*.
(e.g., `dataset`, `attribute`, see above). The annotation element
has two required child elements, `propertyURI` and `valueURI`. Together, these two child elements, along with the *subject*  form a "semantic statement", that can become a "semantic triple". The concept of a triple is covered in more detail  (see [Semantic Triples](#semantic-triples), below). 
Here, we concentrate on the structure of an annotation within the EML doc itself:

- `propertyURI` and `valueURI` elements  
  - the element's text is the URI for the concept in an external vocabulary. The identifier (URI) points to some term in a vocabulary where a definition, description, and potentially that term's relationships to other concepts, are formally modelled. 
  - the XML attribute, `label` is required
      - it should be suitable for application interfaces to display to humans
      - it should be populated by values from the referenced vocabulary's label field (e,g, `rdfs:label` or `skos:prefLabel` ). Note that this assumes the referenced vocabulary is stored as an RDF document, which is current best practice for sharing scientific vocabularies over the Web.

**When are IDs required in the EML doc?**
To be precise, all annotations must have an unambiguous subject. 
At the dataset, entity, or attribute level, the parent element is the *subject*. So, if an element has
an annotation child, it must also have an id (i.e. the subject, or parent element must have an `id` attribute value). 
Annotations at `eml/annotations` or `eml/additionalMetadata` will have subjects defined with a `references` attribute or `describes` element. As with other internal EML references, an `id` is required. 
With EML 2.2.0, the parser will check that an `id` attribute is present on elements with annotation children. 
As a reminder, the `id` must be unique within an EML document.  Ideally, that `id` either is, or can readily be translated into an HTTP URI, that can be dereferenced. See examples below.


### Top-level resource, entity-level, and attribute annotations 

Annotations for top-level resources, entities, and attributes follow the same general pattern.

- The *subject* of the semantic statement is the parent element of the annotation. It must have an `id` attribute. 

<a name="eml-example-1"></a>

#### Example 1: Top-level resource annotation (dataset)


In the following dataset annotation, the semantic statement can be read as "the dataset with the 
id 'dataset-01' is about grassland biome(s)".


- the *subject* of the semantic statement is the `dataset` element containing  the `id` attribute value `"dataset-01"`
- the `annotation` itself has 2 parts: 
    - `propertyURI` is 'http://purl.obolibrary.org/obo/IAO_0000136', and describes the nature of the relationship between the subject (above) and object (valueURI below), using a term from the [Information Artifact Ontology](#iao) (IAO). 
    -  `valueURI` is 'http://purl.obolibrary.org/obo/ENVO_01000177', which resolves to the "grassland biome" term in the [Environment Ontology](#envo) (EnvO). 



```xml
<dataset id="dataset-01">
    <title>Data from Cedar Creek LTER on productivity and species richness for use in a workshop titled
    "An Analysis of the Relationship between Productivity and Diversity using Experimental Results from
    the Long-Term Ecological Research Network" held at NCEAS in September 1996.</title>
    <creator id="clarence.lehman">
        <individualName>
            <salutation>Mr.</salutation>
            <givenName>Clarence</givenName>
            <surName>Lehman</surName>
        </individualName>
    </creator>
    ...    
    <coverage> 
        ...
    </coverage>    
    <annotation>
        <propertyURI label="is about">http://purl.obolibrary.org/obo/IAO_0000136</propertyURI>
        <valueURI label="grassland biome">http://purl.obolibrary.org/obo/ENVO_01000177</valueURI>
    </annotation>
      ...    
</dataset>  
```

Note that the subject `id` here is not in an optimal format, as it is not in the form of a dereferenceable HTTP URI.  Ideally this "local identifier" can be readily translated into an HTTP URI that will provide an unambiguous and persistent identifier for the subject dataset.  E.g. instead of just "dataset-01" it could be something like "http://search.dataone.org/cdr/dataset-01"

<a name="eml-example-2"></a>

#### Example 2: Entity-level annotation

In the following entity-level annotation, the semantic statement can be read as 
"the entity with the id 'https://cn.dataone.org/cn/v2/resolve/urn:uuid:9f0eb128-aca8-4053-9dda-8e7b2c43a81b' is about Mammalia".

- The *subject* of the semantic statement is the `otherEntity` with `id` attribute value, `"https://cn.dataone.org/cn/v2/resolve/urn:uuid:9f0eb128-aca8-4053-9dda-8e7b2c43a81b"`. 
- The annotation itself has 2 parts
    - `propertyURI` is "http://purl.obolibrary.org/obo/IAO_0000136", which resolves to "is about", from [IAO](#iao)
    - `valueURI` is "http://purl.obolibrary.org/obo/NCBITaxon_40674", which resolves to "Mammalia" in the [NCBI Taxon ontology](#ncbi_taxon). 



```xml
<otherEntity id="https://cn.dataone.org/cn/v2/resolve/urn:uuid:9f0eb128-aca8-4053-9dda-8e7b2c43a81b" scope="document">
    <entityName>DBO_MMWatch_SWL2016_MooreGrebmeierVagle.xlsx</entityName>
    <entityDescription>Data contained in the file DBO_MMWatch_SWL2016_MooreGrebmeierVagle.xlsx are marine mammal observations and observation conditions from CCGS Sir Wilfrid Laurier July 10-20, 2016.  Data observations and locations are part of the Distributed Biological Observatory (DBO).</entityDescription>
    <physical scope="document">
        <objectName>DBO_MMWatch_SWL2016_MooreGrebmeierVagle.xlsx</objectName>
        <size unit="bytes">24635</size>
    </physical>
    <entityType>Other</entityType>
    <annotation>
        <propertyURI label="is about">http://purl.obolibrary.org/obo/IAO_0000136</propertyURI>
        <valueURI label="Mammalia">http://purl.obolibrary.org/obo/NCBITaxon_40674</valueURI>  
    <annotation>
</otherEntity>
```
Note in this case that the *subject* is in the form of a (potentially) dereferenceable HTTP URI.  It does unambiguously "point to" the correct data object, which we now know, through semantic annotation, is about "Mammalia".  However, if you dereference this URI, it will immediately lead to a download dialogue.  In the near future, content negotiation will improve this behavior, such that the server-response will be appropriate for the requesting client: e.g. if the requesting client is a Web browser, generate a human-readable HTML-page output; whereas if the requesting client is an R-script, where the URI is an argument to a read.csv function, the data will be downloaded and an appropriate R data-object generated.

<a name="eml-example-3"></a>

#### Example 3: Attribute annotation

In the following attribute annotation, the semantic statement can be read as 
"the attribute with the id 'att.4' contains measurements of type plant cover percentage"

- The subject of the semantic statement is the `attribute` element with the `id` value "att.4". 
- The annotation itself has 2 parts
    - `propertyURI` is "http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType", from the [Extensible Ontology for Observations](#oboe) (OBOE)
    - `valueURI` is "http://purl.dataone.org/odo/ECSO_00001197", which resolves to "Plant Cover Percentage" in the [Ecosystem Ontology](#ecso) (ECSO) 


Related FAQ: [Are all EML dataTable attributes measurements?](#FAQ-are-all-eml-attributes-measurements)


```xml
<attribute id="att.4">
    <attributeName>pctcov</attributeName>
    <attributeLabel>percent cover</attributeLabel>
    <attributeDefinition>The percent ground cover on the field</attributeDefinition>
    <annotation>
        <propertyURI label="contains measurements of type">http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType</propertyURI>
        <valueURI label="Plant Cover Percentage">http://purl.dataone.org/odo/ECSO_00001197</valueURI>
    </annotation>
</attribute>
```

Here again we note that the *subject* is NOT in the form of a dereferenceable HTTP URI.  It does unambiguously "point to" a specific metadata object *within the EML document*, but it would be much more generally useful and powerful if it could stand-alone as an HTTP URI that points to the correct attribute simply by dereferencing the URI with a Web browser client. 

In the near future, DataONE will implement just such a "resolver service", using an HTTP URI similar in format to:
<http://search.dataone.org/data/data-entity_ID/attr.4> 

Dereferencing this URI would place one on an HTML page for that data object, at the location of the appropriate attribute within the appropriate entity.


**[Example 3 as an RDF graph](#rdf-eml-example-3)**


### `eml/annotations` element annotation

An annotation in the `annotations` element differs from Examples 1-3 above, because the subject is directly referred 
to by a `references` attribute. Each `annotation` element has a `references` attribute that 
points to the `id` attribute of the element being annotated. Stated another way, what is listed in the `references` attribute 
is the id of the subject of the semantic annotation. Any of the EML modules may be referenced by the `references` 
attribute and because ids are unique within an EML document, this is a single subject. 

- The *subject* of the semantic statement is implictly the element containing the referenced `id`. 



<a name="eml-example-4"></a>

#### Example 4: `annotations` element annotation

All the annotations for a resource can be grouped together under an `annotations` element. If you use this construct, each
annotation must have its subject specifically identified with a `references` attribute that points to the subject's id. The group
of annotations must be placed TO DO< WHERE IN DOC? [[MPS: I don't know the answer to this. Is there an XML/EML expert in the house?!!!]]

Example 4 contains 3 different annotations. 

In the first, the subject is the `dataTable` element with the `id` 
attribute "CDF-biodiv-table". Its annotation components are analogous to Example 2 above, again referencing terms in [IAO](#iao) and [ENVO](#envo). The semantic statement can be read as 

-  "the dataTable with the `id` 'CDR-biodiv-table' is about grassland biome(s)".

The second and third annotations both have an individual as their subjects -- the `creator` element that has the `id` "adam.shepherd".

Respectively, their semantic statements can be read as

-  "'adam.shepherd', the creator (of the dataset), is a person". 
-  "'adam.shepherd', the creator (of the dataset), is a member of BCO-DMO".

The ontologies used for adam.shepherd are

- in the second annotation 
    - `propertyURI` : an RDF built-in type, "is a"  (as in, `the subject is an instance of a class`)
    - `valueURI` : [schema.org's](#schema.org) concept of a "person"
- third annotation
    - `propertyURI` : another [schema.org](#schema.org) concept for a relationship, "is a member of"
    - `valueURI` : the DOI, which is managed by [re3data.org](#re3data), for the organization BCO-DMO.


```xml
<eml>
   ...
    <dataset id="dataset-01">
        <title>Data from Cedar Creek LTER on productivity and species richness for use in a workshop titled "An Analysis of the Relationship between Productivity and Diversity using Experimental Results from the Long-Term Ecological Research Network" held at NCEAS in September 1996.</title>
        <creator id="adam.shepherd">  [[MPS: I thought at some point I substituted the URI for Adam's ORCID ID here to give a better idea of how this works. Maybe I didn't commit these changes, OR were they removed? ]]
            <individualName>
                <salutation>Mr.</salutation>
                <givenName>Adam</givenName>
                <surName>Shepherd</surName>
            </individualName>
        </creator>
        <dataTable id="CDR-biodiv-table">
            <entityName>CDR LTER-patterns among communities.txt</entityName>  
        ...
       </dataTable>  
    </dataset>
    ...
    <annotations>
        <annotation references="CDR-biodiv-table">
            <propertyURI label="is about">http://purl.obolibrary.org/obo/IAO_0000136</propertyURI>
            <valueURI label="grassland biome">http://purl.obolibrary.org/obo/ENVO_01000177</valueURI>
        </annotation>
        <annotation references="adam.shepherd">
            <propertyURI label="is a">http://www.w3.org/1999/02/22-rdf-syntax-ns#type</propertyURI>
            <valueURI label="Person">https://schema.org/Person</valueURI>
        </annotation>
        <annotation references="adam.shepherd">
            <propertyURI label="member of">https://schema.org/memberOf</propertyURI>
            <valueURI label="BCO-DMO">https://doi.org/10.17616/R37P4C</valueURI>
        </annotation>
    </annotations>
   ...
</eml>
```

As with the prior examples, we really would prefer that the *subjects* of Annotations are dereferenceable HTTP URI's.  If they are not, one must depend on dedicated systems to effectively process them.

**See [Example 4 as an RDF graph](#rdf-eml-example-4)**

### `eml/additionalMetadata` element annotation

If an `additionalMetadata` section holds a semantic annotation, it must have a `describes` element 
(to hold the subject) with a `metadata` element containing at least one `annotation` element. 

- The *subject* of the semantic statement has its id contained in the `describes` element. 
- The annotation itself is within the `additionalMetadata` `metadata` section
- Multiple `annotation` elements may be embedded in the same `metadata` element to assert multiple semantic statements about the same subject.
- To annotate different subjects it's best to use additional `additionalMetadata` sections, each with a single subject

<a name="eml-example-5"></a>

#### Example 5: `additionalMetadata` element annotation

Example 5 shows one of the same annotations as Example 4, but this time, it is contained in an `additionalMetadata` section.

The semantic statements can be read as "'adam.shepherd', the creator (of the dataset), is a person".


- The *subject* of the semantic statement is the `creator` element with the `id` attribute "adam.shepherd". 
- The annotation itself has 2 parts
    - `propertyURI` is "https://schema.org/memberOf", which resolves to "is a member of", from [schema.org](#schema.org)
    - `valueURI` is "https://doi.org/10.17616/R37P4C", a DOI which resolves to "BCO-DMO". 


```xml
<eml>
    ...
    <dataset id="dataset-01">
        <title>Data from Cedar Creek LTER on productivity and species richness for use in a workshop titled "An Analysis of the Relationship between Productivity and Diversity using Experimental Results from the Long-Term Ecological Research Network" held at NCEAS in September 1996.</title>
        <creator id="adam.shepherd">
            <individualName>
                <salutation>Mr.</salutation>
                <givenName>Adam</givenName>
                <surName>Shepherd</surName>
            </individualName>
        </creator>
        <dataTable id="CDR-biodiv-table">
            <entityName>CDR LTER-patterns among communities.txt</entityName>  
         ...
       </dataTable>  
    </dataset>
    ...
     <additionalMetadata>
         <describes>adam.shepherd</describes>
         <metadata>
             <annotation>
                 <propertyURI label="member of">https://schema.org/memberOf</propertyURI>
                 <valueURI label="BCO-DMO">https://doi.org/10.17616/R37P4C</valueURI>
             </annotation>
         </metadata>
     </additionalMetadata>
</eml>
```
<a name="appendix"></a>

## Appendix

<a name="semantic-triples"></a>

### Semantic triples 

Semantic annotations enable the creation of what are called *triples*, that are 3-part statements conforming to the W3C recommended *RDF data model* (learn more: <https://www.w3.org/TR/rdf11-primer/>). 

A *triple* is composed of three parts: a **subject**, a **predicate** (**object property** or **datatype property**), and an **object**.

```
[subject] [predicate] [object]
```

These components are analogous to parts of a sentence: the **subject** and **object** can be thought of as nouns in the sentence and the **predicate** (object property or datatype property) is akin to a verb or relationship that connects the **subject** and **object**. The semantic triple expresses a statement about the associated resource, that is generally the **subject**. 

There are (perhaps unfortunately) several other ways that the components of an RDF statement are sometimes described.  One popular "synonymy" for **subject-predicate-object** is **resource-property-value**, i.e. the subject is referred to as the **resource**, the predicate a **property**, and the object a **value**.  This can be confusing, since the usual definition of a *resource* is any identifiable 'thing' or object, especially one assigned a URI; and by this definition, *resources* can and often do occur in all three components of a triple.  But thinking of a triple as a *resource-property-value* does provide an indication of the directionality of the semantics of an RDF statement.  This latter terminology is also somewhat similar to how analogous components are named in JSON-LD.  Note that JSON-LD is closely compatible with RDF, and one format can often be readily translated to the other (although there are some exceptions).

Semantic annotations added to an EML document can be extracted and processed into a semantic web format, such as RDF/XML. These "semantic" statements, i.e. RDF triples, are interpretable by any machines that can process the W3C standard of RDF. Those RDF statements contribute to the Semantic Web.

<a name="uris"></a>

### URIs 

Ideally, the components of the semantic triple should be globally unique and persistent (unchanging), and consist of resolvable/dereferenceable HTTP uniform resource identifiers (URIs; or more formally, IRI's). The *subjects* of most EML semantic annotations will likely be HTTP URIs that identify the dataset resource itself, or specific attributes or other features within a dataset.  The *objects* of EML semantic annotations, as well as the *predicates* that relate the subject to the object, will most typically be HTTP URI references to terms in controlled vocabularies (also called "knowledge graphs", or "ontologies") accessible through the Web, so that users (or computers) can dereference the URIs and look up precise definitions and relationships of these resources to other terms. 

An example of a URI is "http://purl.obolibrary.org/obo/ENVO_00000097". When entered into the address bar of a web browser, it resolves to the term with a label of "desert area" in the Environment Ontology (EnvO). Users can learn what this URI indicates and explore how the term is related to other terms in the ontology simply by dereferencing its URI in a web browser.  All those other aspects you see on the Web page describing "http://purl.obolibrary.org/obo/ENVO_00000097" are from other RDF statements (triples) related to "ENVO_00000097", and that have been rendered into HTML. From here, you might decide, e.g. that "http://purl.obolibrary.org/obo/ENV0_00000172" ("sandy desert") is a better annotation for your object.

An RDF triple can be constructed as follows, with subject URI, predicate URI, and object URI:

```
<<https://doi.org/10.6073/pasta/06db7b16fe62bcce4c43fd9ddbe43575>> <<http://purl.obolibrary.org/obo/RO_0001025>>   <<http://purl.obolibrary.org/obo/ENVO_00000097>>
```   
   .
   
... indicating that the referenced *dataset* (subject/resource) was *"located in"* (predicate/property) a *"desert area"* (object/value). Note that a blank-space must separate the subject, from the predicate, from the object, and that a "period" completes the triple. This is  a valid RDF triple, expressed in N-Triple syntax.  RDF is most often serialized into XML, however, as Web browsers and many applications are good at parsing XML. 

While our focus here is on the semantic annotation of EML documents, it is easy to see how the RDF statements can be used to describe and inter-relate any resources that have unique, persistent HTTP URIs!

Note that the above *RDF triple* consists of three HTTP URIs. While the exact distinction among what is a URI, a URN, and a URL can be debated, for our purposes, these HTTP URIs are can be considered both the *name* and *web location* of a resource. Content negotiation between a Web server and a client (which might be a browser, or a Python or R script) can enable an HTTP URI to dereference in ways optimized for the requesting client -- e.g. in one case, presenting a human-readable view of metadata for a dataset, and in another, activating a download of that dataset for import into a script.

The software needed to extract semantic annotations out of EML, and convert these into valid RDF triples, is under development at NCEAS and EDI, and through the rOpenSci project. The RDF triple described above, however, hopefully gives an idea of how such triples, constructed of dereferenceable HTTP URIs, can be very useful. 

Related FAQ: [What is the difference between an URI and a URL? ](#FAQ-URIvsURL)




<a name="rdf"></a>

### RDF Graphs 

A graph consists of resources linked to other resources. Thus, the simplest graph structure is when you specify how one resource (node) is linked to another resource (node).

The parts of a triple (subject, predicate, and object) become nodes and links in a graph. Below are examples of how annotations can be converted to RDF triples in RDF/XML, so that the RDF information is now computer-readable. Be aware that there are several formats for serializing RDF, including RDF/XML, Turtle, N-Triples, and N3, that vary in the level of how human-readable they are. 

This process of converting a semantic annotation in EML into RDF, is done by parsing applications under development at EDI, NCEAS, rOpenSci, and other data repositories. Careful examination of the examples below also show references to "owl:Class", "owl:ObjectProperty", and other statements that may not be familiar. These are fundamental *entities* or building blocks in W3C-recommended Semantic Web languages, and are determined by the relationships that the triple component identifiers (HTTP URIs) have within their native knowledge graph/ontology.

Related FAQ: [What is RDFS? ](#FAQ-what-is-rdfs)

Related FAQ: [An image of an RDF Graph is great, but a computer doesn't parse that. What does the RDF look like? ](#FAQ-what-does-RDF-look-like)



<a name="rdf-eml-example-3"></a>

#### Graph from Example 3 (attribute annotation): ([back to Example 3 XML](#eml-example-3))


![RDF example A](images/RDF_example_a.png "Graph from Example 3 (attribute annotation):") 

```xml
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#">
    
    <rdf:Description rdf:about="att.4"> ### See note below
        <owl:ObjectProperty rdf:about="http://ecoinformatics.org/oboe/oboe.1.2/oboe-core.owl#containsMeasurementsOfType">
            <owl:Class rdf:about="http://purl.dataone.org/odo/ECSO_00001197" />
        </owl:ObjectProperty> 
    </rdf>
</rdf:RDF>

```
_Note: The subject described in the `rdf:Description` `about` attribute should actually be a globally unique HTTP URI for the attribute, rather than 'att.4'. The details of how this HTTP URI GUID is constructed are being developed by EDI, NCEAS, and others._

<a name="rdf-eml-example-4"></a>

#### Graph from Example 4 (using `annotations` element): ([back to Example 4 XML](#eml-example-4))

![RDF example B](images/RDF_example_b.png "Graph from Example 4 (using <annotations> element):")

```xml
<rdf:RDF
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#">
    
    <rdf:Description rdf:about="adam.shepherd"> ### See note below 
        <owl:ObjectProperty rdf:about="http://www.w3.org/1999/02/22-rdf-syntax-ns#type">
            <owl:Class rdf:about="https://schema.org/Person" />
        </owl:ObjectProperty> 
        <owl:ObjectProperty rdf:about="https://schema.org/memberOf">
            <owl:Class rdf:about="https://doi.org/10.17616/R37P4C" />
        </owl:ObjectProperty> 
    </rdf>
    
</rdf:RDF>

```
_Note: The subject described in the `rdf:Description` `about` attribute should actually be the globally unique URI issued for 'adam.shepherd'. The details of how this HTTP URI GUID is constructed are being developed by EDI, NCEAS, and others._

<a name="logical-consistency"></a>

### Check for Logical Consistency 

With semantic annotation, you are adding precise definitions of concepts and relationships that can be traversed 
with computer logic. Annotations are not simply a set of loosely structured keywords!  This is a really powerful 
addition to EML, and so it comes with some risk. The main thing you should ensure is that your annotations are 
**logically consistent**.

**The simplest way to check your logic is to write out the RDF triple components and see if it makes sense as a sentence**. 

```
[subject (element-id)]  [predicate (propertyURI)]          [object (valueURI)]
[att.4]                 [contains measurements of type]    [plant cover percentage]

```
The graph examples ([Example 3 RDF graph](#rdf-eml-example-3), [Example 4 RDF graph](#rdf-eml-example-4)) make 'true' statements that are logically consistent:

- att.4 contains measurements of the type plant cover percentage
- adam.shepherd is a person
- adam.shepherd, member of BCO-DMO

However, below is the kind of statement you would NOT want to make:
```
[adam.shepherd] [is a type of] [measurement]
```
If you suspect your RDF triple might look like this, you should go back and examine the way you structured the annotation.

Things to check:

1. Be sure you have used the right classes, properties, or vocabularies for your annotation components
  1. Become familiar with the vocabularies in your annotation, especially definitions and relationships 
  1. Check with your community for specific recommendations on the best vocabularies to use for annotations at different levels. Our examples use [well-constructed vocabularies](#external-vocabularies). 
1. In `additionalMetadata`, don't combine `annotations` with more than one `describes` element. EML allows 1:many `describes` elements in a single `additionalMetadata` section. So if you have 2 `describes` and 2 `annotations`, you will have 4 RDF statements. Make sure they are all true, and if not, break them up into multiple `additionalMetadata` sections.


<a name="glossary"></a>

### Glossary

<a name="glossary-dereference"></a>
**dereference**: To interpret a URI and retrieve information about a resource stored in another location   

<a name="glossary-knowledge-graph"></a>
**knowledge graph**  any knowledge base that is represented as a mathematical graph. 
A graph is a structure for a set of objects, where some pairs of the objects are in some sense related. 
The objects are called nodes or vertices and are interconnected by a set of lines called edges. 
For a semantic triple, the subject and object may be considered nodes and the relationship between 
the nodes as an edge.
 
<a name="glossary-ontology"></a> 
**ontology**: A knowledge *graph* representation of a set of terms, including their names, and descriptions of 
the categories, properties, and relationships among those terms.

<a name="glossary-pointer"></a>
**pointer**: A kind of reference to a datum stored in computer memory.   


<a name="glossary-resolve"></a>
**resolve**: To interpret a URI and determine a course of action for dereferencing the URI.

<a name="glossary-rdf"></a> 
**Resource Description Framework (RDF)**: A family of World Wide Web Consortium (W3C) recommendations that enable the encoding, exchange, and reuse of structured metadata. The RDF data model employs semantic triples composed of a subject, predicate, and object to share and integrate data across different applications and communities through the Web. 


<a name="glossary-uri"></a>
**uniform resource identifier (URI)**: A string of characters that unambiguously identifies a particular resource. For semantic annotations, the components of semantic triples are ideally HTTP URIs that resolve and describe precise definitions and relationships to other terms, using Web technology.

<a name="external-vocabularies"></a>

### Vocabularies and repositories used in examples

Communities using EML annotations will develop recommendations for suitable vocabularies, based
on their own requirements (e.g., domain coverage, structure, adaptability, reliabliity and maintenance model). The following
ontologies are already widely used, and were employed in the examples above:

<a name="ecso"></a>

- **ECSO (Ecosystem Ontology)**  (https://github.com/DataONEorg/sem-prov-ontologies/tree/master/observation).
An ontology for ecosystem measurements under development by the Arctic Data Center and DataONE.

<a name="envo"></a>

- **EnvO (Environment Ontology)**  (http://www.obofoundry.org/ontology/envo.html)
An OBO Foundry ontology for the concise, controlled description of environments.

<a name="iao"></a>

- **IAO (Information Artifact Ontology)**  (http://www.obofoundry.org/ontology/iao.html)
An OBO Foundry ontology of information entities.

<a name="ncbi_taxon"></a>

- **NCBITaxon Ontology** http://www.obofoundry.org/ontology/ncbitaxon.html 
An OBO Foundry ontology representation of the National Center for Biotechnology Information organismal taxonomy.

<a name="oboe"></a>

- **OBOE (Extensible Ontology for Observations)** (https://github.com/NCEAS/oboe) 
An ontology for scientific observations and measurements developed by DataONE and NCEAS.

<a name="re3data"></a>

- **re3data.org (Registry of Research Data Repositories)** (https://www.re3data.org)
A global registry of research data repositories spanning all academic disciplines.

<a name="schema.org"></a>

- **schema.org** (https://schema.org/) 
An initiative to create and support a common set of schemas for structured data markup on web pages. Extensions work with the core vocabulary to provide more specialized and/or deeper vocabularies.



<a name="additional-background"></a>

### Additional background information 
  
Following are tutorials and supplemental background reading

- LinkedDataTools tutorial: http://www.linkeddatatools.com/introducing-rdf
- RDF data model: https://www.w3.org/TR/WD-rdf-syntax-971002/
- W3C RDF primer: https://www.w3.org/TR/rdf11-primer/
- A tidyverse lover’s intro to RDF https://ropensci.github.io/rdflib/articles/rdf_intro.html
 
* Tim Berners-Lee's article on the semantic web: ```Berners-Lee, T., Hendler, J., & Lassila, O. (2001). The semantic web. Scientific american, 284(5), 34-43.```

<a name="FAQ"></a>

## Frequently asked questions

Below are answers to questions some readers had, which may be helpful to you. If you have additional questions, please bring them up in your community for feedback.

<a name="FAQ-what-is-deference"></a>

**Q: What does ‘dereferenced’ mean?**

A: Within the context of semantic annotation, "dereferencing" refers to the process of interpreting a URI, and providing "useful information" back about the Resource of interest. The phrase "resolving a URI" is often used synonymously with "dereferencing", but technically "resolution" refers to the process of determining HOW and WHAT to do with the URI, whereas "dereferencing" is explicitly about the action taken, which is typically retrieving a representation of the Resource of interest. The formal specification for these terms and what they mean is found in the IETF's (Internet Engineering Task Force) RFC (Request for Comment) 3986 (https://tools.ietf.org/html/rfc3986).

**Q: What is the difference between an URI and a URL? Sample URIs look a lot like URLs...**

<a name="FAQ-URIvsURL"></a>

A: The distinctions among URIs (Uniform Resource Identifiers), URLs (Uniform Resource Locators), and URNs (Uniform Resource Names), relate to differentiating the functionalities of identifying a Resource, as opposed to locating a Resource, or doing both. URLs are all URIs (with some edge case exceptions subject to argument), and URNs are also URIs. In many cases, URIs serve both to name and locate a Resource. 

Within the vision of the Semantic Web, URIs are ideally unique, persistent URNs identifying some Web Resource, that can also serve to locate and retrieve (dereference) a representation of that Resource (URLs). The formal specification for these terms and what they mean is found in the IETF's RFC 3986, section 1.1.3 (https://tools.ietf.org/html/rfc3986#section-1.1.3). Another acronym one may encounter with increasing frequency is IRI (Internationalized Resource Identifier) that simply extends the concept of a URI to include full Unicode character set, rather than just ASCII in its construction (https://tools.ietf.org/html/rfc3987).

<a name="FAQ-what-is-skos"></a>

**Q: What is SKOS?**

A: SKOS (Simple Knowledge Management System) is a W3C recommendation for organizing a vocabulary in thesauri, taxonomies, and other classification schemes. SKOS provides a set of concepts and properties, that, when expressed in a formal RDF-compatible syntax, can assist with interpreting the relationship of terms with one another, such as defining some category as broader than another. For example, one could state in SKOS syntax, that "animals" is a broader concept than "mammals". Definitive specification of SKOS can be found at https://www.w3.org/TR/2009/REC-skos-reference-20090818/. SKOS does not provide strong semantics (see RDFS example below), but SKOS concepts and properties can be used within more expressive knowledge organization frameworks, such as RDFS/OWL ontologies.

<a name="FAQ-what-is-rdfs"></a>

**Q: What is RDFS?**

A: RDFS (Resource Description Framework Schema; https://www.w3.org/TR/rdf-schema/) is a W3C recommendation that extends the formal vocabulary for describing Resources expressed in an RDF data model (i.e., in a graph). "Base" RDF https://www.w3.org/TR/2014/REC-rdf11-concepts-20140225/ provides a set of concepts for creating a graph model of data-- consisting of one or more triples relating a subject, predicate, and object. RDFS adds to the base RDF model by specifying a number of well-defined concepts and properties, such as rdfs:Class and rdfs:subClassOf. These and other RDFS classes and properties, enable data and knowledge modellers to express many relationships between the Subject and Object of a Triple. 

In the context of the Semantic Web, the RDF model relies extensively on dereferenceable URIs in the subject and predicate positions, and URIs or literals in the object position (there are small formal exceptions to this not immediately relevant here). RDF triples can be expressed in several syntaxes, including XML, JSON-LD, and Turtle, among others. RDFS then can be used to enrich the precision and expressivity of the components of a triple, as well as clarify the relationships among these.

<a name="FAQ-are-all-eml-attributes-measurements"></a>

**Q: Are all EML dataTable attributes "measurements"?**

A: Yes, in the context of a data table and for annotation purposes, any attribute (observation or column of data) can be 
considered ‘a measurement’. A philosopher might disagree, saying that unique identifiers are not really 
measurements; but many “nominals”, i.e. text strings identifying some class types (e.g. predator, lizard, 
tundra) imply quantification. 

<a name="FAQ-example-labels"></a>

**Q: Can you provide an example of a controlled vocabulary with a rdfs:label or skos:label?**

A: Most Semantic Web vocabularies make extensive use of rdfs:label or SKOS label properties. For example, this URI: http://purl.dataone.org/odo/ECSO_00000536 is from the ECSO ontology, under development at NCEAS by NSF's DataONE and Arctic Data Center. Within that ontology, the URI is associated with an rdfs:label of "Carbon Dioxide Flux", and a skos:altLabel of "CO2 flux". If you dereference the URI, you will see how the BioPortal ontology repository displays this information-- providing a human-readable representation of the underlying RDF/OWL language in which the ontology is stored.

<a name="FAQ-what-does-RDF-look-like"></a>

**Q: An image of an RDF graph is great, but a computer doesn't parse that. What does the RDF look like?**

A: As mentioned above, RDF is a data model based on triples, each of which consists of a subject, predicate, and object. In order to function interoperably on the Web, however, there is the need for these triple components to be constructed of dereferenceable URIs, although the object value can also be a literal. RDF triples can be "serialized" in several syntaxes, including XML, JSON-LD, Turtle, N-Triples, and others. These syntaxes are isomorphic, such that translations of RDF graphs from one serialization to another are available-- enabling consistent interpretation by machines.

Perhaps the most straightforward serialization of RDF graphs for human interpretation is N-Triples, where an RDF triple could look like this:

http://purl.obolibrary.org/obo/CHEBI_16526 http://purl.obolibrary.org/obo/RO_0000087 http://purl.obolibrary.org/obo/CHEBI_76413 .

These are three URIs-- representing the Subject, Predicate, and Object of a Triple. The "." indicates the end of the Triple. Dereferencing these URIs (e.g. a Web browser or specialized application) one can see that this Triple represents the statement:

"Carbon dioxide"(Subject) "has role"(Predicate) "Greenhouse Gas"(Object)

While the phrasing is a bit awkward sounding, the meaning is clear by simply depicting the rdfs:Labels of those terms from the ChEBI (Chemical Entities of Biological Interest) and RO (Relation) ontologies, that are both robust OBO Foundry ontologies.

As another example: http://purl.obolibrary.org/obo/NCIT_C20461 http://purl.org/dc/elements/1.1/creator https://orcid.org/0000-0003-1279-3709 .

that asserts:

"World Wide Web"(Subject) "creator"(Predicate) "Timothy Berners Lee"(Object) .

...although some semantic purists might question whether the Dublin Core property "Creator" can be used in this way as an RDF predicate, since it is not semantically defined-- would its rdfs:label be "creatorOf" or "hasCreator"? (Dublin Core does not say!). Regardless of the formal semantic well-formedness of this Triple, however, one can see the expressive power of the RDF data model, and the value of dereferenceable URIs.

A better solution would be to use the semantically defined term from SIO (the Semantic Science Integrated Ontology) http://semanticscience.org/resource/SIO_000364 as the predicate, with an rdfs:label "has creator"

http://purl.obolibrary.org/obo/NCIT_C20461 http://semanticscience.org/resource/SIO_000364 https://orcid.org/0000-0003-1279-3709 .

...that would translate as (based on content of the rdfs:label):

World Wide Web(Subject) has creator(Predicate) Tim Berners Lee(Object)

or inversely, one could use http://semanticscience.org/resource/SIO_000365 as the predicate, that has rdfs:Label "is creator of"

Tim Berners Lee(Subject) is creator of(Predicate) World Wide Web(Object)

https://orcid.org/0000-0003-1279-3709 http://semanticscience.org/resource/SIO_000365 http://purl.obolibrary.org/obo/NCIT_C20461.

Within the SIO ontology, SIO_000364 and SIO_000365 are defined as inverses of one another. This enables one to ask both questions-- "who created the Web?" (A: Tim Berners Lee), and "what did Tim Berners Lee create" (A: the Web)-- even though you only asserted one of the Triples.

Finally, it is worth noting that one's choice of which Ontologies to use is important. Within the Ecological and Environmental sciences, there are several highly-recommended vocabularies, including those from the OBO Foundry (e.g. ChEBI, EnvO), as well as SIO. Specifically for annotating scientific measurements, the Arctic Data Center and DataONE are developing an Ontology for Ecosystem Measurements, ECSO. We have used all these in the examples.

<a name="FAQ-what-tools"></a>

**Q: Are there tools available to help data managers select subjects, predicates, and objects to annotate with?**

A: Yes, tools are being built to assist with the semantic annotation of EML documents, within the DataONE and Arctic Data Center data repository projects, and others.

