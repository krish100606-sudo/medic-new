package com.example.Health_Data_Management;

import com.example.Health_Data_Management.entity.MedicalCase;
import com.example.Health_Data_Management.entity.Patient;
import com.example.Health_Data_Management.service.DashavidhaService;
import com.example.Health_Data_Management.service.DrugInteractionService;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Collections;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
class HealthDataManagementApplicationTests {

	@Autowired
	private DrugInteractionService drugInteractionService;

	@Autowired
	private DashavidhaService dashavidhaService;

	@Test
	void contextLoads() {
		assertNotNull(drugInteractionService);
		assertNotNull(dashavidhaService);
	}

	@Test
	void testDrugInteractionDetection_WarfarinAspirin() {
		List<DrugInteractionService.DrugInteractionAlert> alerts =
				drugInteractionService.evaluateInteractions("Warfarin 5mg daily, Aspirin 75mg", Collections.emptyList(), "Joint pain");

		assertFalse(alerts.isEmpty());
		assertEquals("CRITICAL", alerts.get(0).getSeverity());
		assertTrue(alerts.get(0).getRiskSummary().contains("Hemorrhage"));
		assertTrue(alerts.get(0).getClinicalMechanism().contains("bleeding"));
	}

	@Test
	void testDrugInteractionDetection_AshwagandhaSedative() {
		List<DrugInteractionService.DrugInteractionAlert> alerts =
				drugInteractionService.evaluateInteractions("Ashwagandha Churna 3g, Clonazepam 0.5mg HS", Collections.emptyList(), "Anxiety and sleep disturbance");

		assertFalse(alerts.isEmpty());
		boolean foundHerbDrug = alerts.stream().anyMatch(a -> a.getDrugA().contains("Ashwagandha"));
		assertTrue(foundHerbDrug);
	}

	@Test
	void testDashavidhaMatrixGeneration_AllTenDimensions() {
		MedicalCase mc = new MedicalCase();
		Patient p = new Patient();
		p.setAge(45);
		p.setGender("Male");
		mc.setPatient(p);
		mc.setChiefComplaint("Acidity and chest burning");
		mc.setAyushPrakriti("Pitta-Kapha Predominant");

		DashavidhaService.DashavidhaMatrix matrix = dashavidhaService.buildMatrix(mc);
		assertNotNull(matrix);
		assertEquals(10, matrix.getDimensions().size());

		assertTrue(matrix.getDimensions().containsKey("PRAKRITI"));
		assertTrue(matrix.getDimensions().containsKey("VIKRITI"));
		assertTrue(matrix.getDimensions().containsKey("SARA"));
		assertTrue(matrix.getDimensions().containsKey("SAMHANANA"));
		assertTrue(matrix.getDimensions().containsKey("PRAMANA"));
		assertTrue(matrix.getDimensions().containsKey("SATMYA"));
		assertTrue(matrix.getDimensions().containsKey("SATVA"));
		assertTrue(matrix.getDimensions().containsKey("AHARA_SHAKTI"));
		assertTrue(matrix.getDimensions().containsKey("VYAYAMA_SHAKTI"));
		assertTrue(matrix.getDimensions().containsKey("VAYA"));

		assertEquals("Madhyama Vaya (Adulthood - Pitta predominant, 45 yrs)",
				matrix.getDimensions().get("VAYA").getClinicalFinding());
	}
}
