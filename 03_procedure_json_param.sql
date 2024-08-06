CREATE OR REPLACE PROCEDURE save_quisionare(dtx text) 
language plpgsql 
AS $$ 
declare -- variable declaration
_j_user j_user%rowtype;
_j_questionnaire j_questionnaire%rowtype;
_pv_questionnaire pv_questionnaire%rowtype;
_id_element integer;
_question m_question%rowtype;
_reason m_reason%rowtype;
dt JSONB;
BEGIN -- stored procedure body
dt = dtx::JSONB;
_j_user.id = nextval('j_user_id_seq'::regclass);
_j_user.fullname = (dt ->> 'fullName')::character varying;
_j_user.email = (dt ->> 'email')::character varying;
_j_user.phone = (dt ->> 'phone')::character varying;
_j_user.gender = (dt ->> 'gender')::character varying;
_j_user.education = (dt ->> 'education')::character varying;
_j_user.category_institution = (dt ->> 'categoryInstitution')::character varying;
_j_user.institution = (dt ->> 'institution')::character varying;
_j_user.active = false;
_j_user.created_at = now();
_j_user.updated_at = now();
_j_user.unique_code = (dt ->> 'uniqueCode')::character varying;

INSERT INTO j_user (id, fullname, email, phone, gender, education, category_institution, institution, active, created_at, updated_at, unique_code) 
VALUES
(_j_user.id, _j_user.fullname, _j_user.email, _j_user.phone, _j_user.gender, _j_user.education, _j_user.category_institution, _j_user.institution, _j_user.active, _j_user.created_at, _j_user.updated_at, _j_user.unique_code);

_j_questionnaire.id = nextval('j_questionnaire_id_seq'::regclass);
_j_questionnaire.suggestion = (dt ->> 'suggestion')::text;
_j_questionnaire.active = false;
_j_questionnaire.visible = false;
_j_questionnaire.created_at = now();
_j_questionnaire.updated_at = now();
_j_questionnaire.total_skm = 0;
_j_questionnaire.is_approved = false;
_j_questionnaire.customer_id = (dt ->> 'customerId')::integer;
_j_questionnaire.created_by_user_id = _j_user.id;
SELECT row_to_json(j_customer) INTO _j_questionnaire.customer FROM j_customer WHERE id = _j_questionnaire.customer_id;
_j_questionnaire.created_by_user = _j_questionnaire.id;
SELECT row_to_json(j_user) INTO _j_questionnaire.created_by_user FROM j_user WHERE id = _j_questionnaire.created_by_user_id;

INSERT INTO public.j_questionnaire (id, suggestion, active, visible, created_at, updated_at, customer, total_skm, created_by_user, is_approved, customer_id, created_by_user_id) 
VALUES
(_j_questionnaire.id, _j_questionnaire.suggestion, _j_questionnaire.active, _j_questionnaire.visible, _j_questionnaire.created_at, _j_questionnaire.updated_at, _j_questionnaire.customer, _j_questionnaire.total_skm, _j_questionnaire.created_by_user, _j_questionnaire.is_approved, _j_questionnaire.customer_id, _j_questionnaire.created_by_user_id);

INSERT INTO public.pv_questionnaire (id, value, visible, active, created_at, updated_at, id_questionnaire, id_question, optional_selected, id_element, question, reason) 
SELECT 
nextval('pv_questionnaire_id_seq'::regclass),
(elem->>'value')::INTEGER,
false,
false,
now(), 
now(), 
_j_questionnaire.id, 
(elem->>'idQuestion')::INTEGER, 
(elem->>'optionalSelected')::character varying, 
(select id_element from m_question where id = (elem->>'idQuestion')::INTEGER), 
(select row_to_json(m_question) from m_question where id = (elem->>'idQuestion')::INTEGER), 
(select row_to_json(m_reason) from m_reason where id = (elem->>'idReason')::INTEGER)
FROM jsonb_array_elements(dt->'pvQuestionnaires') AS elem;

END;
$$

/* execute procedure
 CALL save_quisionare(
'{
  "customerId": 49,
  "fullName": "hilman karyadi tasdik",
  "email": "hilman@gmail.com",
  "phone": "08787",
  "gender": "MALE",
  "education": "S@",
  "categoryInstitution": "UMKM",
  "institution": "SQG",
  "uniqueCode": "12345",
  "suggestion": "Terima kasih",
  "pvQuestionnaires": [
    {
      "idQuestion": 1,
      "value": 1,
      "optionalSelected": "optionalSelected",
      "idReason": 1
    },
    {
      "idQuestion": 2,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 2
    },
    {
      "idQuestion": 3,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 3
    },
    {
      "idQuestion": 4,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 4
    },
    {
      "idQuestion": 5,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 5
    },
    {
      "idQuestion": 6,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 6
    },
    {
      "idQuestion": 7,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 7
    },
    {
      "idQuestion": 8,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 8
    },
    {
      "idQuestion": 9,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 9
    },
    {
      "idQuestion": 10,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 10
    },
    {
      "idQuestion": 11,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 11
    },
    {
      "idQuestion": 12,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 12
    },
    {
      "idQuestion": 13,
      "value": 4,
      "optionalSelected": "optionalSelected",
      "idReason": 13
    }
  ]
}'
)
 */