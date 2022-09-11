package test

import (
	"os"
	"testing"

	"github.com/gruntwork-io/terratest/modules/logger"
	"github.com/gruntwork-io/terratest/modules/terraform"
	test_structure "github.com/gruntwork-io/terratest/modules/test-structure"
)

func SetupTesting(
	t *testing.T,
	workingDir string,
	terraformBinary string,
	terraformVars map[string]interface{},
	terraformEnvVars map[string]string,
) *terraform.Options {

	testDataExists := test_structure.IsTestDataPresent(t, test_structure.FormatTestDataPath(workingDir, "TerraformOptions.json"))

	if testDataExists {
		logger.Logf(t, "Found and loaded test data in %s", workingDir)
		return test_structure.LoadTerraformOptions(t, workingDir)
	} else {
		terraformOptions := &terraform.Options{
			TerraformDir:    workingDir,
			TerraformBinary: terraformBinary,
			Vars:            terraformVars,
			EnvVars:         terraformEnvVars,
		}

		test_structure.SaveTerraformOptions(t, workingDir, terraformOptions)

		logger.Logf(t, "Saved test data in %s so it can be reused later", workingDir)

		return terraformOptions
	}
}

func DeployUsingTerraform(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	t.Run("Terraform Deploy", func(t *testing.T) {
		terraform.InitAndApply(t, terraformOptions)
	})
}

func RedeployUsingTerraform(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	t.Run("Terraform Idempotency", func(t *testing.T) {
		terraform.ApplyAndIdempotent(t, terraformOptions)
	})
}

func TerraformDestroy(t *testing.T, workingDir string) {
	terraformOptions := test_structure.LoadTerraformOptions(t, workingDir)
	t.Run("Terraform Destroy", func(t *testing.T) {
		terraform.Destroy(t, terraformOptions)
	})
	test_structure.CleanupTestDataFolder(t, workingDir)
}

func SetAzSdkEnvVars() {
	os.Setenv("AZURE_CLIENT_ID", os.Getenv("ARM_CLIENT_ID"))
	os.Setenv("AZURE_CLIENT_SECRET", os.Getenv("ARM_CLIENT_SECRET"))
	os.Setenv("AZURE_TENANT_ID", os.Getenv("ARM_TENANT_ID"))
	os.Setenv("AZURE_SUBSCRIPTION_ID", os.Getenv("ARM_SUBSCRIPTION_ID"))
}
